load_js_file('master/FormCustomer.js');

var WindowPasien = Ext.create(dir_sys + 'patient.WindowPasien');

Ext.define('GridCustomerModel', {
    extend: 'Ext.data.Model',
    fields: ['idcustomer','idcustomertype','nocustomer','namecustomer','address','shipaddress','billaddress','telephone','handphone','fax','email','website','city','state','postcode','country','notes','namecustype','status'],
    idProperty: 'id'
});
var storeGridCustomer = Ext.create('Ext.data.Store', {
    pageSize: 100,
    model: 'GridCustomerModel',
    proxy: {
        type: 'ajax',
        url: CLINIC_API + 'master/grid?key='+key,
        actionMethods: {
          read:'GET'
        },
        reader: {
            root: 'rows',
            totalProperty: 'results'
        },
        //simpleSortMode: true
    },
    sorters: [{
        property: 'menu_name',
        direction: 'DESC'
    }]
});

storeGridCustomer.on('beforeload', function(store, operation) {
    operation.params = {
        'idunit':idunit,
        'model':'customerGrid'
    }
})

var smGridCustomer = Ext.create('Ext.selection.CheckboxModel', {
    allowDeselect: true,
    mode: 'MULTI',
    listeners: {
        deselect: function(model, record, index) {
            var selectedLen = smGridCustomer.getSelection().length;
            if (selectedLen == 0) {
                // Ext.getCmp('GridCustomerID').queryById('btnEdit').setDisabled(true);
                Ext.getCmp('GridCustomerID').queryById('btnDelete').setDisabled(true);
            }
        },
        select: function(model, record, index) {
            // Ext.getCmp('GridCustomerID').queryById('btnEdit') .setDisabled(false);
            Ext.getCmp('GridCustomerID').queryById('btnDelete') .setDisabled(false);
        }
    }
});

Ext.define('MY.searchGridCustomer', {
    extend: 'Ext.ux.form.SearchField',
    alias: 'widget.searchGridCustomer',
    store: storeGridCustomer,
    width: 180
});

Ext.define(dir_sys + 'master.GridCustomer', {
    title: 'Daftar Kontak',
    itemId: 'GridCustomerID',
    id: 'GridCustomerID',
    extend: 'Ext.grid.Panel',
    alias: 'widget.GridCustomer',
    store: storeGridCustomer,
    selModel: smGridCustomer,
    loadMask: true,
    columns: [
        {header: 'idcustomer', dataIndex:'idcustomer', hidden:true},
        {header: 'idcustomertype', dataIndex:'idcustomertype', hidden:true},
        {header: 'Nama Kontak', minWidth: 150, dataIndex: 'namecustomer'},
        {header: 'Jenis Kontak', dataIndex:'namecustype'},        
        {header: 'Alamat', minWidth: 250, dataIndex: 'address' },
        {header: 'Alamat Pengiriman', minWidth: 250, dataIndex: 'shipaddress' },
        {header: 'Alamat Penagihan', minWidth: 250, dataIndex: 'billaddress' },
        {header: 'Telp', minWidth: 150, dataIndex: 'telephone' },
        {header: 'Handphone', minWidth: 150, dataIndex: 'handphone' },
        {header: 'Fax', minWidth: 150, dataIndex: 'fax' },
        {header: 'Email', minWidth: 150, dataIndex: 'email' },
        {header: 'Status', dataIndex:'status', minWidth: 100, renderer: function(value){
            return togglearr.map(function(val){return val[1]})[value];
        }},
    ],
    dockedItems: [
        {
            xtype: 'toolbar',
            dock: 'top',
            items: [{
                itemId: 'btnAdd',
                text: 'Pendaftaran Pasien',
                iconCls: 'add-icon',
                handler: function() {
                    FormCustomer.statusform = 'input';
                    FormCustomer.show();
                }
            }, {
                itemId: 'btnEdit',
                text: 'Edit',
                iconCls: 'edit-icon',
                disabled: true,
                hidden:true,
                handler: function() {
                    var grid = Ext.ComponentQuery.query('GridCustomer')[0];
                    var selectedRecord = grid.getSelectionModel().getSelection()[0];
                    var rows = grid.getSelectionModel().getSelection();
                    if (rows.length == 0) {
                        Ext.Msg.alert('Failure', 'Brand is not set!');
                    } else {
                        FormCustomer.statusform = 'edit';
                        var data = null;
                        storeGridCustomer.getRange().every(function(rec){
                            if(rec.data['idcustomer'] == selectedRecord.data['idcustomer']){
                                data = rec;
                                return false; 
                            }
                            return true;
                        });

                        Ext.getCmp('idcustomertype').getStore().load()
                        formCustomer.loadRecord(data);
                        FormCustomer.show();
                    }
                }
            }, {
                itemId: 'btnDelete',
                text: 'Delete',
                iconCls: 'delete-icon',
                disabled: true,
                handler: function() {
                    Ext.Msg.show({
                        title: 'Confirm',
                        msg: 'Delete Selected ?',
                        buttons: Ext.Msg.YESNO,
                        fn: function(btn) {
                            if (btn == 'yes') {
                                var grid = Ext.ComponentQuery.query('GridCustomer')[0];
                                var sm = grid.getSelectionModel();
                                selected = [];
                                Ext.each(sm.getSelection(), function(item) {
                                    selected.push(item.data[Object.keys(item.data)[0]]);
                                });
                                console.log(selected);
                                Ext.Ajax.request({
                                    url: CLINIC_API + 'master/delete',
                                    method: 'POST',
                                    params: {
                                        key:key,
                                        model:'customerGrid',
                                        postdata: Ext.encode(selected),
                                        idmenu:24
                                    },
                                    success: function(form, action) {
                                        var d = Ext.decode(form.responseText);
                                        if (!d.success) {
                                            Ext.Msg.alert('Informasi', d.message);
                                        } else {
                                            storeGridCustomer.load();
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
            }, 
            '->', 
            'Pencarian: ', 
            ' ', 
            {
                xtype: 'searchGridCustomer',
                text: 'Left Button',
            }
        ],
    }, {
        xtype: 'pagingtoolbar',
        store: storeGridCustomer, // same store GridPanel is using
        dock: 'bottom',
        displayInfo: true
        // pageSize:20
    }],
    listeners: {
        render: {
            scope: this,
            fn: function(grid) {
                storeGridCustomer.load();
            }
        },
        itemdblclick: function(dv, record, item, index, e) {
            FormCustomer.statusform = 'edit';
            var data = null;
            storeGridCustomer.getRange().every(function(rec){
                if(rec.data['idcustomer'] == record.data.idcustomer){
                    data = rec;
                    return false; 
                }
                return true;
            });
            console.log(record.data.idcustomertype);
            Ext.getCmp('idcustomertype').getStore().load();
            Ext.getCmp('idcustomertype').setValue(record.data.idcustomertype);
            formCustomer.loadRecord(data);
            FormCustomer.show();
        }
    }
});