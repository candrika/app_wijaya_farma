var formCustomer = Ext.create('Ext.form.Panel', {
    autoWidth: true,
    autoHeight: true,
    url: CLINIC_API + 'master/save_form',
    method:'POST',
    baseParams: { idmenu: 24 },
    bodyStyle: 'padding:5px',
    labelAlign: 'top',
    autoScroll: true,
    layout: 'hbox',
    defaults: {
        padding: '5 10 5 5',
    },
    fieldDefaults: {
        msgTarget: 'side',
        blankText: 'is required',
        labelWidth: 160,
        anchor: '100%',
        width: 380
    },
    items: [{
            items: [
                { xtype: 'hiddenfield', name: 'key', allowBlank: false,value:key},
                { xtype: 'hiddenfield', name: 'model', allowBlank: false,value:'customerGrid'},
                { xtype: 'hiddenfield', name: 'idcustomer', allowBlank: false },
                { xtype: 'hiddenfield', name: 'statusformCustomer', allowBlank: false },
                { xtype: 'textfield', name: 'nocustomer', fieldLabel: 'No Customer', allowBlank: false, maxLength: 50 },
                { xtype: 'textfield', name: 'namecustomer', fieldLabel: 'Name', allowBlank: false, maxLength: 50 },
                { xtype: 'comboxcustomertype', name: 'idcustomertype',id: 'idcustomertype', fieldLabel: 'Type', allowBlank: false, emptyText: 'Choose Type...' },
                { xtype: 'textarea', name: 'address', fieldLabel: 'Address', allowBlank: false, maxLength: 225 },
                { xtype: 'textarea', name: 'shipaddress', fieldLabel: 'Shipping Address', maxLength: 225 },
                { xtype: 'textarea', name: 'billaddress', fieldLabel: 'Bill Address', maxLength: 225 },
                { xtype: 'comboxswitch', name: 'status', fieldLabel: 'Status', allowBlank: false },
            ],
        },
        {
            items: [
                { xtype: 'textfield', name: 'telephone', fieldLabel: 'Telp', allowBlank: false, maxLength: 20 },
                { xtype: 'textfield', name: 'handphone', fieldLabel: 'HP', allowBlank: false, maxLength: 20 },
                { xtype: 'textfield', name: 'fax', fieldLabel: 'Fax', maxLength: 20 },
                { xtype: 'textfield', name: 'email', fieldLabel: 'Email', maxLength: 150 },
                { xtype: 'textfield', name: 'website', fieldLabel: 'Website', maxLength: 50 },
                { xtype: 'textfield', name: 'city', fieldLabel: 'City', allowBlank: false, maxLength: 50 },
                { xtype: 'textfield', name: 'state', fieldLabel: 'State', allowBlank: false, maxLength: 50 },
                { xtype: 'textfield', name: 'postcode', fieldLabel: 'Post Code',maxLength: 10 },
                { xtype: 'textfield', name: 'country', fieldLabel: 'Country', maxLength: 50 },
                { xtype: 'textarea', name: 'notes', fieldLabel: 'Notes', maxLength: 225 },
            ],
        }
    ],
    buttons: [{
        text: 'Cancel',
        handler: function() {
            FormCustomer.hide();
        }
    }, {
        text: 'Save',
        handler: function() {
            if (formCustomer.isValid()) {
                formCustomer.submit({
                    success: function(form, action) {
                        Ext.Msg.alert('Success', 'Customer berhasil ditambahkan');
                        FormCustomer.hide();
                        Ext.getCmp('GridCustomerID').getStore().load();
                    },
                    failure: function(form, action) {
                        Ext.Msg.alert('Failed', action.result ? action.result.message : 'No response');
                    }
                });
            } else {
                Ext.Msg.alert("Error!", "Your form is invalid!");
            }
        }
    }]
});

var FormCustomer = Ext.create('widget.window', {
    title: 'Form Customer',
    header: {
        titlePosition: 2,
        titleAlign: 'center'
    },
    modal: true,
    closable: true,
    closeAction: 'hide',
    autoWidth: true,
    autoHeight: true,
    layout: 'fit',
    border: false,
    items: [formCustomer],
    listeners: {
        'show': function(FormCustomer) {
            formCustomer.getForm().findField('statusformCustomer').setValue(FormCustomer.statusform);
        },
        'hide': function() {
            formCustomer.getForm().reset();
        }

    }
});