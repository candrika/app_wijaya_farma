
Ext.define('KitchenSink.model.tree.Task', {
    extend: 'Ext.data.Model',
    fields: [
        'namepos', 'text', 'id', 'idaccounttype', 'lock', 'idparent', 'idaccount', 'accname', 'accnumber', 'balance',
        'description', 'classname', 'acctypename', 'prefixno', 'idclassificationcf', 'display', 'active'
    ]
});

var storeAccount = new Ext.data.TreeStore({
    model: 'KitchenSink.model.tree.Task',
    proxy: {
        type: 'ajax',
        url: SITE_URL + 'account/tesJsonTree/0'
    },
    root: {
        text: ' ',
        id: '0',
        expanded: false
    },
    autoload: false,
    folderSort: true,
    sorters: [{
        property: 'accnumber',
        direction: 'ASC'
    }]
});

Ext.define(dir_sys+'account.GridDaftarAkun', {
    extend: 'Ext.tree.Panel', 
    alias:'widget.GridDaftarAkun',  
    xtype: 'tree-grid',
    id: 'GridDaftarAkun',
    title:'Daftar Akun',
    height: 300,
    useArrows: true,
    rootVisible: false,
    // multiSelect: true,
    // singleExpand: true,
    loadMask: true,
    enableColumnResize: true,
    // rowLines: true,
    listeners:{
        render:{
            scope:this,
            fn:function(grid){
                storeAccount.load();
            }
        }
    },    
    viewConfig:{
        getRowClass:function(record){
            if (record.get('active') == 't') {
                return 'null';
            } else if (record.get('active') == 'f') {
                return 'child-row';
            } else if (record.get('id') == 0) {
                return 'adult-row';
            }
        }
    },
    initComponent: function() {
        this.width = 600;
        
        Ext.apply(this, {
            store:storeAccount,
            columns: [{
                    xtype: 'treecolumn',
                    text: 'No Akun',
                    minWidth: 200,
                    sortable: true,
                    dataIndex: 'accnumber'
                }, {
                    xtype: 'treecolumn',
                    text: 'Nama Akun',
                    // renderer: renderTip,
                    minWidth: 400,
                    sortable: true,
                    dataIndex: 'text'
                },
                {
                    text: 'Tipe Akun',
                    sortable: true,
                    minWidth: 170,
                    dataIndex: 'acctypename'
                },
                {
                    text: 'Deskripsi',
                    minWidth: 200,
                    sortable: true,
                    dataIndex: 'description',
                    hidden: true,
                },
                {
                    xtype: 'numbercolumn',
                    text: 'Saldo',
                    align: 'right',
                    sortable: true,
                    minWidth: 165,
                    dataIndex: 'balance'
                },
                {
                    text: 'Edit',
                    width: 55,
                    flex:1,
                    menuDisabled: true,
                    xtype: 'actioncolumn',
                    tooltip: 'Edit task',
                    align: 'center',
                    icon: BASE_URL + 'assets/icons/fam/pencil.png',
                    handler: function(grid, rowIndex, colIndex, actionItem, event, record, row) {
                        Ext.Msg.alert('Editing' + (record.get('done') ? ' completed task' : '') , record.get('task'));
                    },
                }
            ],
                        dockedItems: [{
                xtype: 'toolbar',
                dock: 'top',
                items: [{
                        xtype: 'comboxunit',
                        width: 300,
                        valueField: 'idunit',
                        hidden:true,
                        id: 'cbUnitTreeAccount',
                        listeners: {
                            'change': function(field, newValue, oldValue) {
                                storeAccountAktive.load({
                                    params: {
                                        'extraparams': 'a.idunit:' + Ext.getCmp('cbUnitTreeAccount').getValue()
                                    }
                                });

                                Ext.Ajax.request({
                                    url: SITE_URL + 'account/cekAccount',
                                    method: 'POST',
                                    params: {
                                        'idunit': Ext.getCmp('cbUnitTreeAccount').getValue()
                                    },
                                    success: function(response) {
                                        var result = Ext.decode(response.responseText);
                                        if (!result.success) {
                                            windowAccWizard.show();
                                            // Ext.MessageBox.confirm('Daftar', 'Anda belum membuat daftar akun. Apakah anda ingin sistem membuat rekening perkiraan secara otomatis?', confirmAkunWizard);
                                        }
                                    },
                                    failure: function(opt, succes, response) {
                                        Ext.MessageBox.confirm(response);
                                        //                        Ext.MessageBox.confirm('Saldo Awal', 'Anda belum membuat daftar akun. Apakah anda ingin sistem membuat rekening perkiraan secara otomatis?', confirmAkunWizard);
                                    }
                                });
                            }
                        }
                    }, '->'
                    //                         {
                    //                             xtype: 'button',
                    // //                            width:100,
                    //                             handler: function(button, event) {
                    //                                 Ext.getCmp('GridTreeAcc2').expandAll();
                    //                             },
                    //                             // flex: 1,
                    //                             text: 'Expand'
                    //                         }, {
                    //                             // xtype: 'button',
                    //                             handler: function(button, event) {
                    //                                 Ext.getCmp('GridTreeAcc2').collapseAll();
                    //                             },
                    //                             // flex: 1,
                    //                             text: 'Collapse'
                    //                         }
                ]
            }, {
                xtype: 'toolbar',
                dock: 'top',
                items: [                    {
                        // itemId: 'addAcc',
                        text: 'Tambah Akun',
                        iconCls: 'add-icon',
                        handler: function() {
                            var grid = Ext.ComponentQuery.query('GridTreeAcc2')[0];
                            var selectedRecord = grid.getSelectionModel().getSelection()[0];
                            var data = grid.getSelectionModel().getSelection();
                            Ext.getCmp('accnameinduk').show();
                            // if (data.length === 0) {
                            //     Ext.Msg.alert('Failure', 'Pilih Induk Account terlebih dahulu!');
                            // } else 

                            if (Ext.getCmp('cbUnitTreeAccount').getValue() === null) {
                                Ext.Msg.alert('Failure', 'Pilih unit terlebih dahulu!');
                            } else {
                                var formacc = Ext.getCmp('formAccount');

                                formacc.getForm().reset();

                                //                            if (selectedRecord.data.display == null)
                                //                            {
                                //                                Ext.getCmp("displayacc").setValue(true);
                                //                            } else {
                                //                                Ext.getCmp("displayacc").setValue(false);
                                //                            }
                                if(data.length === 0) {
                                    Ext.getCmp('idparent').setValue(0);
                                    // Ext.getCmp('classname').setReadOnly(false);
                                    Ext.getCmp('accnameinduk').hide();
                                } else if (selectedRecord.data.id == 0) {
                                    Ext.getCmp('idparent').setValue(0);
                                    Ext.getCmp('classname').setReadOnly(false);

                                } else {
                                    console.log(selectedRecord)
                                        // Ext.getCmp('classname').setReadOnly(true);
                                    Ext.getCmp('idparent').setValue(selectedRecord.data.idaccount);
                                    Ext.getCmp('accnameinduk').setValue(selectedRecord.data.text);
                                    // Ext.getCmp('classname').setValue(selectedRecord.data.classname);
                                    // Ext.getCmp('prefixno').setValue(selectedRecord.data.prefixno);
                                    Ext.getCmp('prefixno2').setValue(selectedRecord.data.prefixno);
                                    Ext.getCmp('idclassificationcf').setValue(selectedRecord.data.idclassificationcf);
                                }


                                Ext.getCmp('idunitAddAcc').setValue(Ext.getCmp('cbUnitTreeAccount').getValue());
                                Ext.getCmp('stateformacc').setValue('input');

                                wAccount.show();
                                headerAkunStore.load();
                            }
                        }
                    },
                    {
                        text:'Import Akun',
                        iconCls:'page_excel',
                        handler:function(){
                            windowPopupImportCOA.show();
                        }
                    },
                    {
                        // itemId: 'addAcc',
                        text: 'Hapus Akun',
                        // hidden:true,
                        iconCls: 'delete-icon',
                        handler: function() {
                            var grid = Ext.ComponentQuery.query('GridTreeAcc2')[0];
                            var selectedRecord = grid.getSelectionModel().getSelection()[0];
                            var data = grid.getSelectionModel().getSelection();
                            if (data.length === 0) {
                                Ext.Msg.alert('Failure', 'Pilih Akun terlebih dahulu!');
                            } else if (Ext.getCmp('cbUnitTreeAccount').getValue() == null) {
                                Ext.Msg.alert('Failure', 'Pilih Unit terlebih dahulu!');
                            } else {
                                Ext.MessageBox.confirm('Menghapus Akun', 'Apakah anda yakin untuk menghapus akun ini? <br><br> <b>Jika akun terhapus makan akun tersebut tidak akan muncul di daftar akun perkiraan dan proses transaksi.</b>', confirmHapusAkun);

                            }
                        }
                    }, '-',
                    {
                        xtype: 'textfield',
                        id: 'searchAcc',
                        fieldLabel: 'Pencarian',
                        listeners: {
                            specialkey: function(f, e) {
                                if (e.getKey() == e.ENTER) {
                                    storeAccount.load({
                                        params: {
                                            'accname': Ext.getCmp('searchAcc').getValue(),
                                            'extraparams': 'idunit:' + Ext.getCmp('cbUnitTreeAccount').getValue()
                                        }
                                    });
                                }
                            }
                        }
                    }, {
                        //                        itemId: 'reloadDataAcc',
                        text: 'Cari',
                        iconCls: 'search',
                        handler: function() {
                            storeAccount.load({
                                params: {
                                    'accname': Ext.getCmp('searchAcc').getValue(),
                                }
                            });
                        }
                    }, {
                        // itemId: 'reloadDataAcc',
                        text: 'Refresh',
                        iconCls: 'refresh',
                        handler: function() {
                            // var grid = Ext.getCmp('GridTreeAcc2');
                            // grid.getView().refresh();
                            // storeAccountAktive.load({
                            //             params: {
                            //                 'extraparams': 'idunit:' + Ext.getCmp('cbUnitTreeAccount').getValue()
                            //             }
                            //         });
                            Ext.getCmp('searchAcc').setValue(null)
                            // Ext.getCmp('GridTreeAcc2').expandAll();
                            storeAccount.load({
                                params: {
                                    'extraparams': 'a.idunit:' + Ext.getCmp('cbUnitTreeAccount').getValue()
                                }
                            });
                        }
                    }]
            }]
        });
        this.callParent();
    }
});