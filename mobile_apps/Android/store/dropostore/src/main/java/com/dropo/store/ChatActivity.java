package com.dropo.store;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.dropo.store.R;
import com.dropo.store.adapter.ChatAdapter;
import com.dropo.store.models.datamodel.Message;
import com.dropo.store.utils.Constant;

import com.firebase.ui.database.FirebaseRecyclerOptions;
import com.firebase.ui.database.SnapshotParser;
import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

public class ChatActivity extends BaseActivity {

    private ChatAdapter chatAdapter;
    private RecyclerView rcvChat;
    private DatabaseReference firebaseDatabaseReference;
    private Button btnSend;
    private EditText messageEditText;
    private String MESSAGES_CHILD = "Demo";
    private SimpleDateFormat webFormat;
    private String CHAT_TYPE = "";
    private String receiver_id = "";

    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);
        toolbar = findViewById(R.id.toolbar);
        setToolbar(toolbar, R.drawable.ic_back, R.color.color_app_theme);
        ((TextView) findViewById(R.id.tvToolbarTitle)).setText(getIntent().getStringExtra(Constant.TITLE));

        MESSAGES_CHILD = getIntent().getStringExtra(Constant.ORDER_ID);
        CHAT_TYPE = getIntent().getStringExtra(Constant.TYPE);
        receiver_id = getIntent().getStringExtra(Constant.RECEIVER_ID);

        initFirebaseChat();
        rcvChat = findViewById(R.id.rcvChat);
        btnSend = findViewById(R.id.btnSend);
        btnSend.setOnClickListener(this);
        btnSend.setEnabled(false);
        btnSend.setAlpha(0.5f);
        messageEditText = findViewById(R.id.messageEditText);
        messageEditText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                if (charSequence.toString().trim().length() > 0) {
                    btnSend.setEnabled(true);
                    btnSend.setAlpha(1f);
                } else {
                    btnSend.setEnabled(false);
                    btnSend.setAlpha(0.5f);
                }
            }

            @Override
            public void afterTextChanged(Editable editable) {
            }
        });
        initChatRcv();
    }

    @Override
    public void onPause() {
        if (chatAdapter != null) {
            chatAdapter.stopListening();
        }
        super.onPause();
    }

    @Override
    public void onResume() {
        super.onResume();
        if (chatAdapter != null) {
            chatAdapter.startListening();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu1) {
        super.onCreateOptionsMenu(menu1);
        menu = menu1;
        setToolbarEditIcon(false, 0);
        setToolbarSaveIcon(false);
        return true;
    }

    public void onClick(View view) {
        if (view.getId() == R.id.btnSend) {
            sendMessage();
        }
    }

    private void initChatRcv() {
        final LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        linearLayoutManager.setStackFromEnd(true);
        SnapshotParser<Message> parser = dataSnapshot -> dataSnapshot.getValue(Message.class);

        DatabaseReference messagesRef = firebaseDatabaseReference.child(MESSAGES_CHILD).child(CHAT_TYPE);
        FirebaseRecyclerOptions<Message> options = new FirebaseRecyclerOptions.Builder<Message>().setQuery(messagesRef, parser).build();

        chatAdapter = new ChatAdapter(this, options);
        chatAdapter.registerAdapterDataObserver(new RecyclerView.AdapterDataObserver() {
            @Override
            public void onItemRangeInserted(int positionStart, int itemCount) {
                super.onItemRangeInserted(positionStart, itemCount);
                int friendlyMessageCount = chatAdapter.getItemCount();
                int lastVisiblePosition = linearLayoutManager.findLastCompletelyVisibleItemPosition();
                // If the recycler view is initially being loaded or the user is at the bottom of
                // the list, scroll
                // to the bottom of the list to show the newly added message.
                if (lastVisiblePosition == -1 || (positionStart >= (friendlyMessageCount - 1) && lastVisiblePosition == (positionStart - 1))) {
                    rcvChat.scrollToPosition(positionStart);
                } else {
                    rcvChat.scrollToPosition(friendlyMessageCount - 1);
                }
            }
        });

        rcvChat.setLayoutManager(linearLayoutManager);
        rcvChat.setItemAnimator(null);
        rcvChat.setAdapter(chatAdapter);
    }

    private void initFirebaseChat() {
        webFormat = new SimpleDateFormat(Constant.DATE_TIME_FORMAT_WEB, Locale.US);
        webFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        firebaseDatabaseReference = FirebaseDatabase.getInstance().getReference();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
    }

    public void setAsReadMessage(String id) {
        DatabaseReference chatMessage = firebaseDatabaseReference.child(MESSAGES_CHILD).child(CHAT_TYPE).child(id).child("is_read");
        chatMessage.setValue(true);
    }

    private void sendMessage() {
        if (firebaseDatabaseReference != null) {
            String key = firebaseDatabaseReference.child(MESSAGES_CHILD).child(CHAT_TYPE).push().getKey();
            if (!TextUtils.isEmpty(key)) {
                Message chatMessage = new Message(key, Integer.parseInt(CHAT_TYPE), messageEditText.getText().toString().trim(), webFormat.format(new Date()), Constant.STORE_CHAT_ID, receiver_id, false);
                firebaseDatabaseReference.child(MESSAGES_CHILD).child(CHAT_TYPE).child(key).setValue(chatMessage);
                messageEditText.setText("");
            }
        }
    }
}