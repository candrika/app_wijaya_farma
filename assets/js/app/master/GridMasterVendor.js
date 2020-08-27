Ext.define('GridMasterVendorModel', {
    extend: 'Ext.data.Model',
    fields: ['vendor_id','vendor_code','vendor_name','description','status'],
    idProperty: 'id'
});

var storeGridMasterVendor = Ext.create('Ext.data.Store', {
    pageSize: 100,
    model: 'GridMasterVendorModel',
    //remoteSort: true,
    // autoload:true,
    proxy: {
        type: 'ajax',
        url: CLINIC_API + 'master/grid?key='+key,
        actionMethods:{
            read:'GET'
        },
        reader: {
            root: 'rows',
            totalProperty: 'results'
        },
    },
    sorters: [{
        property: 'menu_name',
        direction: 'DESC'
    }]
});

storeGridMasterVendor.on('beforeload',function(store,operation){
    operation.params={
        'idunit':idunit,
        'model':'productvendor'
    }
});

var formMasterVendor= Ext.create('Ext.form.Panel', {
    id: 'formMasterVendor',
    autoWidth:true,
    autoHeight:true,
    url: CLINIC_API + 'master/save_form',
    bodyStyle: 'padding:5px',
    labelAlign: 'top',
    autoScroll: true,
    fieldDefaults: {
        msgTarget: 'side',
        blankText: 'Tidak Boleh Kosong',
        labelWidth: 130,
        width: 400
    },
    items: [{
            xtype: 'hiddenfield',
            name: 'vendor_id',
            id: 'vendor_id'
        },
        {
            xtype: 'hiddenfield',
            name: 'model',
            value: 'productvendor'
        },
        {
            xtype:'hiddenfield',
            name:'key',
            value:key
        },
        {
            xtype: 'hiddenfield',
            name: 'statusformMasterVendor',
            id: 'statusformMasterVendor'
        },
        {
            xtype: 'textfield',
            fieldLabel: 'Kode Vendor',
            allowBlank: false,
            name: 'vendor_code'
        },
        {
            xtype: 'textfield',
            fieldLabel: 'Nama Vendor',
            allowBlank: false,
            name: 'vendor_name'
        },
        {
            xtype: 'textfield',
            fieldLabel: 'Description',
            allowBlank: false,
            name: 'description'
        },
        { 
            xtype: 'comboxswitch', 
            name: 'status', 
            fieldLabel: 'Status', 
            allowBlank: false 
        },
    ],
    buttons: [{
        text: 'Batal',
        handler: function() {
            var win = Ext.getCmp('windowPopupMasterVendor');
            Ext.getCmp('formMasterVendor').getForm().reset();
            win.hide();
        }
    }, {
        id: 'BtnMasterVendorSimpan',
        text: 'Simpan',
        handler: function() {
            var form = this.up('form').getForm();
            if (form.isValid()) {
                form.submit({
                    success: function(form, action) {
                        Ext.Msg.alert('Success', action.result.message);
                        Ext.getCmp('formMasterVendor').getForm().reset();
                        Ext.getCmp('windowPopupMasterVendor').hide();
                        storeGridMasterVendor.load();
                    },
                    failure: function(form, action) {
                        Ext.Msg.alert('Failed', action.result ? action.result.message : 'No response');
                        //                            storeGridMasterVendor.load();
                    }
                });
            } else {
                Ext.Msg.alert("Error!", "Your form is invalid!");
            }
        }
    }]
});

var wMasterVendor= Ext.create('widget.window', {
    id: 'windowPopupMasterVendor',
    title: 'Data Supplier',
    header: {
        titlePosition: 2,
        titleAlign: 'center'
    },
    closable: true,
    closeAction: 'hide',
    autoWidth: true,
    autoHeight: true,
    layout: 'fit',
    border: false,
    items: [formMasterVendor]
});


Ext.define('MY.searchGridMasterVendor', {
    extend: 'Ext.ux.form.SearchField',
    alias: 'widget.searchGridMasterVendor',
    store: storeGridMasterVendor,
    width: 180
});
var smGridMasterVendor = Ext.create('Ext.selection.CheckboxModel', {
    allowDeselect: true,
    mode: 'SINGLE',
    listeners: {
        deselect: function(model, record, index) {
            var selectedLen = smGridMasterVendor.getSelection().length;
            if (selectedLen == 0) {
                console.log(selectedLen);
                Ext.getCmp('btnDeleteMasterVendor').disable();
            }
        },
        select: function(model, record, index) {
            Ext.getCmp('btnDeleteMasterVendor').enable();
        }
    }
});
Ext.define(dir_sys + 'master.GridMasterVendor', {
    itemId: 'GridMasterVendorID',
    id: 'GridMasterVendorID',
    title:'Vendor',
    extend: 'Ext.grid.Panel',
    alias: 'widget.GridMasterVendor',
    store: storeGridMasterVendor,
    loadMask: true,
    columns: [{
        header: 'id_vendor',
        dataIndex: 'id_vendor',
        hidden: true
    },
    {
        header: 'Kode Vendor',
        dataIndex: 'vendor_code',
        minWidth: 150
    },
    {
        header: 'Nama Vendor',
        dataIndex: 'vendor_name',
        minWidth: 150
    },
    {
        header: 'Deskripsi',
        dataIndex: 'description',
        minWidth: 150,
        flex:1,
    }, {
        header: 'Status',
        dataIndex: 'status',
        minWidth: 150,
        renderer: function(value){
            return togglearr.map(function(val){return val[1]})[value];
        }
    }],
    dockedItems: [{
        xtype: 'toolbar',
        dock: 'top',
        items: [{
            itemId: 'addMasterVendor',
            text: 'Tambah',
            iconCls: 'add-icon',
            handler: function() {
                wMasterVendor.show();
                Ext.getCmp('statusformMasterVendor').setValue('input');
            }
        }, {
            itemId: 'editMasterVendor',
            text: 'Ubah',
            iconCls: 'edit-icon',
            handler: function() {
                var grid = Ext.ComponentQuery.query('GridMasterVendor')[0];
                var selectedRecord = grid.getSelectionModel().getSelection()[0];
                var data = grid.getSelectionModel().getSelection();
                console.log(selectedRecord.data);
                if (data.length == 0) {
                    Ext.Msg.alert('Failure', 'Pilih data terlebih dahulu!');
                } else {
                    //Ext.getCmp('kodejenjangmaster').setReadOnly(false);
                    var formMasterVendor= Ext.getCmp('formMasterVendor');
                    formMasterVendor.getForm().load({
                        url: CLINIC_API + 'master/form_loader',
                        method:'GET',
                        params: {
                            extraparams: 'a.vendor_id=' + selectedRecord.data.vendor_id,
                            model:'productvendor',
                            key:key
                        },
                        success: function(form, action) {
                            // Ext.Msg.alert("Load failed", action.result.errorMessage);
                        },
                        failure: function(form, action) {
                            Ext.Msg.alert("Load failed", action.result.errorMessage);
                        }
                    })
                    wMasterVendor.show();
                    Ext.getCmp('statusformMasterVendor').setValue('edit');
                    // Ext.getCmp('TabSupplier').setActiveTab(0);
                }
            }
        }, {
            id: 'btnDeleteMasterVendor',
            text: 'Hapus',
            iconCls: 'delete-icon',
            handler: function() {
                Ext.Msg.show({
                    title: 'Confirm',
                    msg: 'Delete Selected ?',
                    buttons: Ext.Msg.YESNO,
                    fn: function(btn) {
                        if (btn == 'yes') {
                            var grid = Ext.ComponentQuery.query('GridMasterVendor')[0];
                            var sm = grid.getSelectionModel();
                            selected = [];
                            Ext.each(sm.getSelection(), function(item) {
                                selected.push(item.data[Object.keys(item.data)[0]]);
                            });
                            Ext.Ajax.request({
                                url: SITE_URL + 'backend/ext_delete/MasterVendor/master',
                                method: 'POST',
                                params: {
                                    postdata: Ext.encode(selected),
                                    idmenu:24
                                },
                                success: function(form, action) {
                                    var d = Ext.decode(form.responseText);
                                    if (!d.success) {
                                        Ext.Msg.alert('Informasi', d.message);
                                    } else {
                                        storeGridMasterVendor.load();
                                    }
                                },
                                failure: function(form, action) {
                                    Ext.Msg.alert('Failed', action.result ? action.result.message : 'No response');
                                }
                            });
                            
                        }
                    }
                });
            },
            //                    disabled: true
        }, '->', 'Pencarian: ', ' ', {
            xtype: 'searchGridMasterVendor',
            text: 'Left Button'
        }]
    }, {
        xtype: 'pagingtoolbar',
        store: storeGridMasterVendor, // same store GridPanel is using
        dock: 'bottom',
        displayInfo: true
        // pageSize:20
    }],
    listeners: {
        render: {
            scope: this,
            fn: function(grid) {
                storeGridMasterVendor.load();
            }
        },
        itemdblclick: function(dv, record, item, index, e) {
            // var formAgama = Ext.create('formAgama');
            var formMasterVendor= Ext.getCmp('formMasterVendor');
            wMasterVendor.show();
            formMasterVendor.getForm().load({
                url: CLINIC_API + 'master/form_loader',
                method:'GET',
                params: {
                    extraparams: 'a.vendor_id=' + record.data.vendor_id,
                    model:'productvendor',
                    key:key
                },
                success: function(form, action) {
                    // Ext.Msg.alert("Load failed", action.result.errorMessage);
                },
                failure: function(form, action) {
                    Ext.Msg.alert("Load failed", action.result.errorMessage);
                }
            })
            //            
            //            Ext.getCmp('kddaerahS').setReadOnly(true);
            Ext.getCmp('statusformMasterVendor').setValue('edit');

            Ext.getCmp('TabSupplier').setActiveTab(0);
        }
    }
});