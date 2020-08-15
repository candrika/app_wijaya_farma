Ext.define('Ext.ux.form.SearchField', {
    extend: 'Ext.form.field.Trigger',
     
    alias: 'widget.searchfield',
     
    trigger1Cls: Ext.baseCSSPrefix + 'form-clear-trigger',
     
    trigger2Cls: Ext.baseCSSPrefix + 'form-search-trigger',
     
    hasSearch : false,
    paramName : 'query',
     
    initComponent: function(){
        this.callParent(arguments);
        this.on('specialkey', function(f, e){
            if(e.getKey() == e.ENTER){
                this.onTrigger2Click();
            }
        }, this);
    },
     
    afterRender: function(){
        // console.log(this.inputEl.item);
        this.callParent();
        this.triggerEl.item(0).setDisplayed('block');
        // this.triggerEl.item(1).setStyle('margin-left', '-17px');
        this.inputEl.setStyle('width','162px');
    },
     
    onTrigger1Click : function(){
        var me = this,
            store = me.store,
            proxy = store.getProxy(),
            val;
             
        if (me.hasSearch) {
            me.setValue('');
            proxy.extraParams[me.paramName] = '';
            proxy.extraParams.start = 0;
            store.load();
            me.hasSearch = false;
            me.triggerEl.item(0).setDisplayed('block');
            // me.triggerEl.item(1).setStyle('margin-left', '-17px');
            this.inputEl.setStyle('width','162px');
            me.doComponentLayout();
        }
    },
 
    onTrigger2Click : function(){
        var me = this,
            store = me.store,
            proxy = store.getProxy(),
            value = me.getValue();
             
        if (value.length < 1) {
            me.onTrigger1Click();
            return;
        }
        proxy.extraParams[me.paramName] = value;
        proxy.extraParams.start = 0;
        store.load();
        me.hasSearch = true;
        me.triggerEl.item(0).setDisplayed('block');
        // me.triggerEl.item(1).setStyle('margin-left', '0');
        this.inputEl.setStyle('width','162px');
        me.doComponentLayout();
    }
});