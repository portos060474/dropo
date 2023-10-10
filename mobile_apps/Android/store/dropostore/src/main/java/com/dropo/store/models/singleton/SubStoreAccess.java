package com.dropo.store.models.singleton;

import android.os.Bundle;

import com.dropo.store.models.datamodel.SubStoreAccessService;

import java.util.HashMap;
import java.util.List;

public class SubStoreAccess {
    public static final int PERMISSION_GRANTED = 1;
    public static final int PERMISSION_NOT_GRANTED = 0;
    public static final String CREATE_ORDER = "store/create_order";
    public static final String PROVIDERS = "store/providers";
    public static final String SERVICE = "store/service";
    public static final String ORDER = "store/order";
    public static final String DELIVERIES = "store/deliveries";
    public static final String HISTORY = "store/history";
    public static final String GROUP = "store/group";
    public static final String PRODUCT = "store/product";
    public static final String PROMO_CODE = "store/promocode";
    public static final String SETTING = "store/setting";
    public static final String EARNING = "store/earning";
    public static final String WEEKLY_EARNING = "store/weekly_earning";
    public static final String SUB_STORE = "sub_store";
    private static final SubStoreAccess ourInstance = new SubStoreAccess();
    private static HashMap<String, Boolean> subStoreAccessPermission;

    private SubStoreAccess() {
        subStoreAccessPermission = new HashMap<>();
    }

    public static SubStoreAccess getInstance() {
        return ourInstance;
    }

    public static void saveState(Bundle state) {
        if (state != null) {
            state.putSerializable("sub_store_access_permission", subStoreAccessPermission);
        }

    }

    public static void restoreState(Bundle state) {
        if (state != null) {
            subStoreAccessPermission = (HashMap<String, Boolean>) state.getSerializable("sub_store_access_permission");
        }
    }

    public void loadAccess(List<SubStoreAccessService> subStoreAccessServices) {
        subStoreAccessPermission.clear();
        if (subStoreAccessServices != null) {
            for (SubStoreAccessService subStoreAccessService : subStoreAccessServices) {
                subStoreAccessPermission.put(subStoreAccessService.getUrl(), subStoreAccessService.getPermission() == PERMISSION_GRANTED);
            }
            subStoreAccessPermission.put(SUB_STORE, false);
        }
    }

    public boolean isAccess(String accessFeature) {
        if (subStoreAccessPermission != null && !subStoreAccessPermission.isEmpty()) {
            return subStoreAccessPermission.get(accessFeature) == null || subStoreAccessPermission.get(accessFeature);
        } else {
            return true;
        }


    }

    public void clearStoreAccess() {
        subStoreAccessPermission.clear();
    }
}
