package com.dropo.store.bluetoothprinter;

public class Command {

    public static final byte PIECE = (byte) 0xFF;
    public static final byte NUL = (byte) 0x00;
    private static final byte ESC = 0x1B;
    private static final byte FS = 0x1C;
    private static final byte GS = 0x1D;
    private static final byte US = 0x1F;
    private static final byte DLE = 0x10;
    private static final byte DC4 = 0x14;
    private static final byte DC1 = 0x11;
    private static final byte SP = 0x20;
    private static final byte NL = 0x0A;
    private static final byte FF = 0x0C;
    // Printer initialization
    public static byte[] ESC_Init = new byte[]{ESC, '@'};

    /**
     * Print command
     */
    //Print and wrap
    public static byte[] LF = new byte[]{NL};

    //Print and feed paper
    public static byte[] ESC_J = new byte[]{ESC, 'J', 0x00};
    public static byte[] ESC_d = new byte[]{ESC, 'd', 0x00};

    //Print a self-test page
    public static byte[] US_vt_eot = new byte[]{US, DC1, 0x04};

    //Buzzer instruction
    public static byte[] ESC_B_m_n = new byte[]{ESC, 'B', 0x00, 0x00};

    //Cutter instruction
    public static byte[] GS_V_n = new byte[]{GS, 'V', 0x00};
    public static byte[] GS_V_m_n = new byte[]{GS, 'V', 'B', 0x00};
    public static byte[] GS_i = new byte[]{ESC, 'i'};
    public static byte[] GS_m = new byte[]{ESC, 'm'};

    /**
     * Character setting command
     */
    //Set character right spacing
    public static byte[] ESC_SP = new byte[]{ESC, SP, 0x00};

    //Set character print font format
    public static byte[] ESC_ExclamationMark = new byte[]{ESC, '!', 0x00};

    //Set font double height and width
    public static byte[] GS_ExclamationMark = new byte[]{GS, '!', 0x00};

    //Set up reverse printing
    public static byte[] GS_B = new byte[]{GS, 'B', 0x00};

    //Cancel/select 90 degree rotation printing
    public static byte[] ESC_V = new byte[]{ESC, 'V', 0x00};

    //Choose font type (mainly ASCII code)
    public static byte[] ESC_M = new byte[]{ESC, 'M', 0x00};

    //Select/cancel bold instruction
    public static byte[] ESC_G = new byte[]{ESC, 'G', 0x00};
    public static byte[] ESC_E = new byte[]{ESC, 'E', 0x00};

    //Select/cancel upside-down printing mode
    public static byte[] ESC_LeftBrace = new byte[]{ESC, '{', 0x00};

    //Set the height of the underline point (character)
    public static byte[] ESC_Minus = new byte[]{ESC, 45, 0x00};

    //Character mode
    public static byte[] FS_dot = new byte[]{FS, 46};

    //Chinese Character Mode
    public static byte[] FS_and = new byte[]{FS, '&'};

    //Set Chinese printing mode
    public static byte[] FS_ExclamationMark = new byte[]{FS, '!', 0x00};

    //Set the height of the underline point (Chinese characters)
    public static byte[] FS_Minus = new byte[]{FS, 45, 0x00};

    //Set the left and right spacing of Chinese characters
    public static byte[] FS_S = new byte[]{FS, 'S', 0x00, 0x00};

    //Select character code page
    public static byte[] ESC_t = new byte[]{ESC, 't', 0x00};

    /**
     * Formatting instructions
     */
    //Set default line spacing
    public static byte[] ESC_Two = new byte[]{ESC, 50};

    //Set line spacing
    public static byte[] ESC_Three = new byte[]{ESC, 51, 0x00};

    //Set alignment mode
    public static byte[] ESC_Align = new byte[]{ESC, 'a', 0x00};

    //Set left margin
    public static byte[] GS_LeftSp = new byte[]{GS, 'L', 0x00, 0x00};

    //Set absolute print position
    //Set the current position to the beginning of the line (nL + nH x 256).
    //If the setting position is outside the specified printing area, this command is ignored
    public static byte[] ESC_Relative = new byte[]{ESC, '$', 0x00, 0x00};

    //Set relative print position
    public static byte[] ESC_Absolute = new byte[]{ESC, 92, 0x00, 0x00};

    //Set print area width
    public static byte[] GS_W = new byte[]{GS, 'W', 0x00, 0x00};

    /**
     * Status command
     */
    //Real-time status transmission instructions
    public static byte[] DLE_eot = new byte[]{DLE, 0x04, 0x00};

    //Real-time cash box instruction
    public static byte[] DLE_DC4 = new byte[]{DLE, DC4, 0x00, 0x00, 0x00};

    //Standard cash box instructions
    public static byte[] ESC_p = new byte[]{ESC, 'F', 0x00, 0x00, 0x00};

    /**
     * Barcode setting instructions
     */
    //Choose HRI printing method
    public static byte[] GS_H = new byte[]{GS, 'H', 0x00};

    //Set barcode height
    public static byte[] GS_h = new byte[]{GS, 'h', (byte) 0xa2};

    //Set barcode width
    public static byte[] GS_w = new byte[]{GS, 'w', 0x00};

    //Set HRI character font font
    public static byte[] GS_f = new byte[]{GS, 'f', 0x00};

    //Barcode left offset instruction
    public static byte[] GS_x = new byte[]{GS, 'x', 0x00};

    //Print barcode instructions
    public static byte[] GS_k = new byte[]{GS, 'k', 'A', FF};

    //QR code related instructions
    public static byte[] GS_k_m_v_r_nL_nH = new byte[]{ESC, 'Z', 0x03, 0x03, 0x08, 0x00, 0x00};


}
