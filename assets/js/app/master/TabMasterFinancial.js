Ext.create(dir_sys + 'account.GridDaftarAkun');
Ext.create(dir_sys + 'setup.GridSetupTax');
Ext.create(dir_sys + 'setup.Gridlinkedacc');
// Ext.create(dir_sys + 'master.GridMasterCurrency');

Ext.define(dir_sys + 'master.TabMasterFinancial', {
    extend: 'Ext.tab.Panel',
    id: 'TabMasterFinancial',
    alias: 'widget.TabMasterFinancial',
    activeTab: 0,
    autoWidth: '100%',
    autoScroll: true,
    plain:true,
    defaults: {
        autoScroll: true
    },
    items: [
        {
            xtype: 'GridDaftarAkun'
        },
        {
            xtype:'GridSetupTax'
        },
        {
            xtype:'Gridlinkedacc'
        }
    ], listeners: {
        render: {
            scope: this,
            fn: function(grid) {
                // disableUnitMasterCustomer();
            }
        }
    }
});