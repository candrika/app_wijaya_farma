//START PAJAK KELUAR
Ext.define('GridCOAPajakKeluaranPopupModel', {
    extend: 'Ext.data.Model',
    fields: ['idaccount','idunit','idaccounttype','accnumber','accname','balance','description','namaunit','acctypename'],
    idProperty: 'id'
});
var storeCOAPajakKeluaranPopup = Ext.create('Ext.data.Store', {
    pageSize: 100,
    model: 'GridCOAPajakKeluaranPopupModel',
    //remoteSort: true,
    // autoload:true,
    proxy: {
        type: 'ajax',
        url: SITE_URL + 'backend/ext_get_account/gridaccount/account',
        actionMethods: 'POST',
        reader: {
            root: 'rows',
            totalProperty: 'results'
        },
        //simpleSortMode: true
    },
    sorters: [{
        property: 'idaccount',
        direction: 'ASC'
    }]
})
//acc list
Ext.define('GridCOAPajakKeluaranPopup', {
    itemId: 'GridCOAPajakKeluaranPopup',
    id: 'GridCOAPajakKeluaranPopup',
    extend: 'Ext.grid.Panel',
    alias: 'widget.GridCOAPajakKeluaranPopup',
    store: storeCOAPajakKeluaranPopup,
    loadMask: true,
    columns: [
    {
            text: 'Edit',
            width: 45,
            // menuDisabled: true,
            xtype: 'actioncolumn',
            tooltip: 'Pilih Akun Ini',
            align: 'center',
            icon: BASE_URL + 'assets/icons/fam/arrow_right.png',
            handler: function(grid, rowIndex, colIndex, actionItem, event, selectedRecord, row) {
               // setValueAcc(selectedRecord,'wCoaPajakKeluaranPopup','_coa_hutang_pi');
               Ext.getCmp('coa_tax_sales_id').setValue(selectedRecord.data.idaccount);
               Ext.getCmp('acc_tax_sales').setValue(selectedRecord.data.accname);
               Ext.getCmp('wCoaPajakKeluaranPopup').hide();
            }
        },
        {header: 'idaccount', dataIndex: 'idaccount', hidden: true},
        {header: 'idunit', dataIndex: 'idunit', hidden: true},
        {header: 'No Akun', dataIndex: 'accnumber',},
        {header: 'Nama Akun', dataIndex: 'accname', minWidth: 150,flex:1},
        {header: 'Saldo', dataIndex: 'balance', minWidth: 150,xtype:'numbercolumn',align:'right',hidden:true},
        {header: 'Tipe Akun', dataIndex: 'acctypename', minWidth: 170},
        // {header: 'Deskripsi', dataIndex: 'description', minWidth: 250},
    ]
    , dockedItems: [
        {
            xtype: 'toolbar',
            dock: 'top',
            items: [
                '->',
                'Pencarian: ', ' ',
                {
                    xtype: 'searchGridAcc',
                    text: 'Left Button'
                }

            ]
        }, {
            xtype: 'pagingtoolbar',
            store: storeCOAPajakKeluaranPopup, // same store GridPanel is using
            dock: 'bottom',
            displayInfo: true
                    // pageSize:20
        }
    ]
});

Ext.define(dir_sys + 'setup.wCoaPajakKeluaranPopup', {
    extend: 'Ext.window.Window',
    id: 'wCoaPajakKeluaranPopup',
    alias: 'widget.wCoaPajakKeluaranPopup',
    title: 'Pilih Akun',
    header: {
        titlePosition: 2,
        titleAlign: 'center'
    },
    closable: true,
    closeAction: 'hide',
//    autoWidth: true,
    width: 660,
    height: panelHeight,
    layout: 'fit',
    border: false,
    items: [{
            xtype:'GridCOAPajakKeluaranPopup'
    }]
});

// var wCoaPajakKeluaranPopup = Ext.create('wCoaPajakKeluaranPopup');
//END PAJAK KELUAR