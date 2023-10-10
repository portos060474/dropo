package com.dropo.store.bluetoothprinter;

import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Context;
import android.os.Environment;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.dropo.store.adapter.OrderListAdapter;
import com.dropo.store.models.datamodel.Item;
import com.dropo.store.models.datamodel.Order;
import com.dropo.store.models.datamodel.OrderDetail;
import com.dropo.store.models.datamodel.OrderDetails;
import com.dropo.store.parse.ParseContent;
import com.dropo.store.utils.PreferenceHelper;
import com.dropo.store.utils.Utilities;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.TimeZone;

public final class PrintManager {
    private static OutputStream outputStream;
    private final BluetoothSocket btSocket;
    private final Context context;
    private final boolean isTesting;
    private final Charset charset = StandardCharsets.ISO_8859_1;// print in different language
    private final PrintStatusListener printStatusListener;

    /**
     * Instantiates a new Print manager.
     *
     * @param context             the context
     * @param btSocket            the bt socket
     * @param isTesting           the is testing
     * @param printStatusListener the print status listener
     */
    public PrintManager(Context context, BluetoothSocket btSocket, boolean isTesting, @NonNull PrintStatusListener printStatusListener) {
        this.btSocket = btSocket;
        this.context = context;
        this.isTesting = isTesting;
        this.printStatusListener = printStatusListener;
    }

    private void printTestFile(OrderDetail orderDetail) {
        File file = new File(context.getExternalFilesDir(Environment.DIRECTORY_PICTURES), "test" + ".prn");
        try {

            outputStream = new FileOutputStream(file);
            //print command

            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
                Thread.currentThread().interrupt();
            }
            try {
                printTestFormat(orderDetail);
                outputStream.flush();
                outputStream.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
            System.out.println("file created: " + file);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Print.
     *
     * @param orderDetail the order detail
     */
    public void print(OrderDetail orderDetail) {
        if (isTesting) {
            printTestFile(orderDetail);
            printStatusListener.completePrinting();
        } else {
            if (btSocket != null && btSocket.isConnected()) {
                if (btSocket.getRemoteDevice().getBondState() == BluetoothDevice.BOND_NONE) {
                    Toast.makeText(context, "Please pair bluetooth device from system setting", Toast.LENGTH_LONG).show();
                    return;
                }
                OutputStream opstream = null;
                try {
                    opstream = btSocket.getOutputStream();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                outputStream = opstream;
                //print command

                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                    Thread.currentThread().interrupt();
                }
                try {
                    printFormat(orderDetail);
                    outputStream.flush();
                    printStatusListener.completePrinting();
                } catch (IOException e) {
                    e.printStackTrace();
                    printStatusListener.errorPrinting(e.getMessage());
                }
            }
        }
    }

    /*
     *SendDataByte
     */
    private void SendDataByte(byte[] data) {
        if (outputStream != null && (btSocket != null || isTesting)) {
            try {
                outputStream.write(data);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }


    }

    private void SendDataString(String data) {
        if (data.length() > 0 && outputStream != null && (btSocket != null || isTesting)) {
            try {
                outputStream.write(data.getBytes(charset));
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void printTestFormat(OrderDetail orderDetail) {


        String div = "--------------------------------\n";
        String newLine = "\n";
        SendDataByte(new byte[]{0x1C});
        SendDataByte(new byte[]{0x2E});
        SendDataByte(new byte[]{0x1B});
        SendDataByte(new byte[]{0x74});
        SendDataByte(new byte[]{0x10});
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString("INVOICE");
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataString(div);
        SendDataString(PreferenceHelper.getPreferenceHelper(context).getName());
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString(orderDetail.getOrderPaymentDetail().isIsPaymentPaid() ? "*PAID*" : "PENDING");
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataString(div);
        SendDataString(PreferenceHelper.getPreferenceHelper(context).getAddress());
        SendDataString(newLine);
        SendDataString(div);
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString("ORDER: " + orderDetail.getOrderPaymentDetail().getOrderUniqueId());
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataString("Crated: " + getDate(orderDetail.getOrder().getCreatedAt()));
        SendDataString(newLine);
        if (orderDetail.getOrder().isIsScheduleOrder()) {
            SendDataString("Schedule: " + getScheduleDate(orderDetail.getOrder()));
            SendDataString(newLine);
        }
        SendDataString(div);
        SendDataString(orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getName());
        SendDataString(newLine);
        SendDataString(orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getCountryPhoneCode() + orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getPhone());
        SendDataString(newLine);
        SendDataString(div);
        List<OrderDetails> orderDetails = orderDetail.getCartDetail().getOrderDetails();
        for (OrderDetails detail : orderDetails) {
            List<Item> items = detail.getItems();
            for (Item item : items) {
                if (item.getTotalItemAndSpecificationPrice() > 0) {
                    String price = getPrice(item.getTotalItemAndSpecificationPrice());
                    String name = item.getQuantity() + " " + item.getItemName();
                    SendDataString(spaceCalculator(name, price, 0));
                    SendDataString(newLine);
                } else if (item.getItemPrice() + item.getTotalSpecificationPrice() > 0) {
                    String price = getPrice(item.getItemPrice() + item.getTotalSpecificationPrice());
                    String name = item.getQuantity() + " " + item.getItemName();
                    SendDataString(spaceCalculator(name, price, 0));
                    SendDataString(newLine);
                }
            }
        }
        SendDataByte(PrinterCommand.POS_S_Align(2));
        SendDataString("---------");
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_S_Align(0));
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString(spaceCalculator("Sub Tot", getPrice(orderDetail.getOrderPaymentDetail().getTotalOrderPrice()), 1));
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataString(spaceCalculator("Fees", getPrice(orderDetail.getOrderPaymentDetail().getTotalDeliveryPrice()), 0));
        SendDataString(newLine);
        if (orderDetail.getOrderPaymentDetail().getPromoPayment() > 0) {
            SendDataString(spaceCalculator("Discount", getPrice(orderDetail.getOrderPaymentDetail().getPromoPayment()), 0));
            SendDataString(newLine);
        }
        SendDataByte(PrinterCommand.POS_S_Align(2));
        SendDataString("---------");
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_S_Align(0));
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString(spaceCalculator("Total", getPrice(orderDetail.getOrderPaymentDetail().getTotal()), 1));
        SendDataByte(PrinterCommand.POS_S_Align(0));
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataByte(PrinterCommand.POS_Set_PrtAndFeedPaper(48));
        SendDataByte(Command.GS_V_m_n);


    }

    private void printFormat(OrderDetail orderDetail) {

        String div = "--------------------------------\n";
        String newLine = "\n";
        SendDataByte(new byte[]{0x1C});
        SendDataByte(new byte[]{0x2E});
        SendDataByte(new byte[]{0x1B});
        SendDataByte(new byte[]{0x74});
        SendDataByte(new byte[]{0x10});
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString("INVOICE");
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataString(div);
        SendDataString(PreferenceHelper.getPreferenceHelper(context).getName());
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString(orderDetail.getOrderPaymentDetail().isIsPaymentPaid() ? "*PAID*" : "PENDING");
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataString(div);
        SendDataString(PreferenceHelper.getPreferenceHelper(context).getAddress());
        SendDataString(newLine);
        SendDataString(div);
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString("ORDER: " + orderDetail.getOrderPaymentDetail().getOrderUniqueId());
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataString("Crated: " + getDate(orderDetail.getOrder().getCreatedAt()));
        SendDataString(newLine);
        if (orderDetail.getOrder().isIsScheduleOrder()) {
            SendDataString("Schedule: " + getScheduleDate(orderDetail.getOrder()));
            SendDataString(newLine);
        }
        SendDataString(div);
        SendDataString(orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getName());
        SendDataString(newLine);
        SendDataString(orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getCountryPhoneCode() + orderDetail.getCartDetail().getDestinationAddresses().get(0).getUserDetails().getPhone());
        SendDataString(newLine);
        SendDataString(div);
        List<OrderDetails> orderDetails = orderDetail.getCartDetail().getOrderDetails();
        for (OrderDetails detail : orderDetails) {
            List<Item> items = detail.getItems();
            for (Item item : items) {
                if (item.getTotalItemAndSpecificationPrice() > 0) {
                    String price = getPrice(item.getTotalItemAndSpecificationPrice());
                    String name = item.getQuantity() + " " + item.getItemName();
                    SendDataString(spaceCalculator(name, price, 0));
                    SendDataString(newLine);
                } else if (item.getItemPrice() + item.getTotalSpecificationPrice() > 0) {
                    String price = getPrice(item.getItemPrice() + item.getTotalSpecificationPrice());
                    String name = item.getQuantity() + " " + item.getItemName();
                    SendDataString(spaceCalculator(name, price, 0));
                    SendDataString(newLine);
                }
            }
        }
        SendDataByte(PrinterCommand.POS_S_Align(2));
        SendDataString("---------");
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_S_Align(0));
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString(spaceCalculator("Sub Tot", getPrice(orderDetail.getOrderPaymentDetail().getTotalOrderPrice()), 1));
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataString(spaceCalculator("Fees", getPrice(orderDetail.getOrderPaymentDetail().getTotalDeliveryPrice()), 0));
        SendDataString(newLine);
        if (orderDetail.getOrderPaymentDetail().getPromoPayment() > 0) {
            SendDataString(spaceCalculator("Discount", getPrice(orderDetail.getOrderPaymentDetail().getPromoPayment()), 0));
            SendDataString(newLine);
        }
        SendDataByte(PrinterCommand.POS_S_Align(2));
        SendDataString("---------");
        SendDataString(newLine);
        SendDataByte(PrinterCommand.POS_S_Align(0));
        SendDataByte(PrinterCommand.POS_Set_FontSize(1, 1));
        SendDataString(spaceCalculator("Total", getPrice(orderDetail.getOrderPaymentDetail().getTotal()), 1));
        SendDataByte(PrinterCommand.POS_S_Align(0));
        SendDataByte(PrinterCommand.POS_Set_FontSize(0, 0));
        SendDataByte(PrinterCommand.POS_Set_PrtAndFeedPaper(48));
        SendDataByte(Command.GS_V_m_n);


    }

    private String spaceCalculator(String left, String right, int fontSize) {
        int size = 0;
        StringBuilder stringBuilder = new StringBuilder();
        switch (fontSize) {
            case 0:
                size = 32;
                break;
            case 1:
                size = 15;
                break;
            case 2:
                size = 10;
                break;
        }
        if (left.length() + right.length() >= size) {
            String[] splitStringEvery = splitStringEvery(left, size - (right.length() + 4));
            for (int i = 0; i < splitStringEvery.length; i++) {
                if (i == splitStringEvery.length - 1) {
                    if (splitStringEvery[i].length() + right.length() >= size) {
                        String[] splitStringEvery2 = splitStringEvery(splitStringEvery[i], (size / 2));
                        for (int k = 0; k < splitStringEvery2.length; k++) {
                            stringBuilder.append(splitStringEvery[i]);
                            stringBuilder.append("\n");
                            if (k == splitStringEvery2.length - 1) {
                                size = size - (splitStringEvery2[i].length() + right.length());
                                stringBuilder.append(splitStringEvery2[i]);
                                for (int j = 0; j < size; j++) {
                                    stringBuilder.append(" ");
                                }
                                stringBuilder.append(right);
                            }
                        }

                    } else {
                        size = size - (splitStringEvery[i].length() + right.length());
                        stringBuilder.append(splitStringEvery[i]);
                        for (int j = 0; j < size; j++) {
                            stringBuilder.append(" ");
                        }
                        stringBuilder.append(right);
                    }
                } else {
                    stringBuilder.append(splitStringEvery[i]);
                    stringBuilder.append("\n");
                }
            }

        } else {
            size = size - (left.length() + right.length());
            stringBuilder.append(left);
            for (int i = 0; i < size; i++) {
                stringBuilder.append(" ");
            }
            stringBuilder.append(right);
        }


        return stringBuilder.toString();

    }

    private String getDate(String date) {
        try {
            Date dateWeb = ParseContent.getInstance().webFormat.parse(date);
            return ParseContent.getInstance().dateTimeFormat_am.format(dateWeb);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return "";
    }

    private String getPrice(double price) {
        return ParseContent.getInstance().decimalTwoDigitFormat.format(price);
    }

    private String getScheduleDate(Order order) {
        try {
            Date date = ParseContent.getInstance().webFormat.parse(order.getScheduleOrderStartAt());
            if (!TextUtils.isEmpty(order.getTimeZone())) {
                ParseContent.getInstance().dateFormat.setTimeZone(TimeZone.getTimeZone(order.getTimeZone()));
                ParseContent.getInstance().timeFormat.setTimeZone(TimeZone.getTimeZone(order.getTimeZone()));
            }

            String stringDate = ParseContent.getInstance().dateFormat.format(date) + " " + ParseContent.getInstance().timeFormat.format(date);

            if (!TextUtils.isEmpty(order.getScheduleOrderStartAt2())) {
                Date date2 = ParseContent.getInstance().webFormat.parse(order.getScheduleOrderStartAt2());
                stringDate = stringDate + " - " + ParseContent.getInstance().timeFormat.format(date2);

            }
            return stringDate;
        } catch (ParseException e) {
            Utilities.handleException(OrderListAdapter.class.getName(), e);
        }
        return "";
    }

    private String[] splitStringEvery(String s, int interval) {
        int arrayLength = (int) Math.ceil(((s.length() / (double) interval)));
        String[] result = new String[arrayLength];

        int j = 0;
        int lastIndex = result.length - 1;
        for (int i = 0; i < lastIndex; i++) {
            result[i] = s.substring(j, j + interval);
            j += interval;
        } //Add the last bit
        // add space hear for quantity
        result[lastIndex] = "  " + s.substring(j);

        return result;
    }

    /**
     * The interface Print status listener.
     */
    public interface PrintStatusListener {

        /**
         * Complete printing.
         */
        void completePrinting();

        /**
         * Error printing.
         *
         * @param message the message
         */
        void errorPrinting(String message);
    }
}
