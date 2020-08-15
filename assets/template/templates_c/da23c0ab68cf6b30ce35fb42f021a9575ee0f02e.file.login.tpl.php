<?php /* Smarty version Smarty-3.1.15, created on 2020-08-07 19:33:24
         compiled from "C:\xampp\htdocs\wijaya_farma\\assets\template\templates\login.tpl" */ ?>
<?php /*%%SmartyHeaderCode:16597416395f0ba5a575cae8-00761192%%*/if(!defined('SMARTY_DIR')) exit('no direct access allowed');
$_valid = $_smarty_tpl->decodeProperties(array (
  'file_dependency' => 
  array (
    'da23c0ab68cf6b30ce35fb42f021a9575ee0f02e' => 
    array (
      0 => 'C:\\xampp\\htdocs\\wijaya_farma\\\\assets\\template\\templates\\login.tpl',
      1 => 1596821533,
      2 => 'file',
    ),
  ),
  'nocache_hash' => '16597416395f0ba5a575cae8-00761192',
  'function' => 
  array (
  ),
  'version' => 'Smarty-3.1.15',
  'unifunc' => 'content_5f0ba5a5d32173_94224342',
  'variables' => 
  array (
    'companyname' => 0,
    'appname' => 0,
    'assets_url' => 0,
    'site_url' => 0,
  ),
  'has_nocache_code' => false,
),false); /*/%%SmartyHeaderCode%%*/?>
<?php if ($_valid && !is_callable('content_5f0ba5a5d32173_94224342')) {function content_5f0ba5a5d32173_94224342($_smarty_tpl) {?><!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title><?php echo $_smarty_tpl->tpl_vars['companyname']->value;?>
 - <?php echo $_smarty_tpl->tpl_vars['appname']->value;?>
</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <script src='<?php echo $_smarty_tpl->tpl_vars['assets_url']->value;?>
/ext/ext-all.js'></script>
    <<script src='<?php echo $_smarty_tpl->tpl_vars['assets_url']->value;?>
/ext/ext-theme-classic.js'></script>
    <link href="<?php echo $_smarty_tpl->tpl_vars['assets_url']->value;?>
/ext/resources/ext-theme-classic/ext-theme-classic-all.css" rel="stylesheet">
    <link href="<?php echo $_smarty_tpl->tpl_vars['assets_url']->value;?>
/ext/src/ux/css/ItemSelector.css" rel="stylesheet">

    <style type="text/css">
    .logo_centered {
        position: fixed;
        top: 30%;
        left: 50%;
        /* bring your own prefixes */
        transform: translate(-50%, -50%);
    }

    .mainPageGroupPanel .x-panel-header {
        color:#15428b;
        border-color:#99bbe8;
        /*background-image: url(../images/default/panel/white-top-bottom.gif);*/
    }
    </style>
    
    <!-- <center><img src="<?php echo $_smarty_tpl->tpl_vars['assets_url']->value;?>
/images/Logo redsfin.png" width="200" class="logo_centered"/></center> -->

    <script type="text/javascript">
    var SITE_URL = '<?php echo $_smarty_tpl->tpl_vars['site_url']->value;?>
';
    var appname = '<?php echo $_smarty_tpl->tpl_vars['appname']->value;?>
';
    </script>
    <script src='<?php echo $_smarty_tpl->tpl_vars['assets_url']->value;?>
/js/login.js'></script>
    <style>
    body{
        position:relative;
        /*background: url(http://8pic.ir/images/cgnd518gxezm1m2blqo7.jpg) no-repeat center center fixed;*/
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
        width:100%;
        height:100%;
        margin:0
    }
    body:after{
        opacity: 0.19;
        position:fixed;
        content:"";
        top:0;
        left:0;
        right:0;
        bottom:0;
        /*background:rgba(0,0,255,0.5);*/
        background: url(<?php echo $_smarty_tpl->tpl_vars['assets_url']->value;?>
/images/pharmacy.png) no-repeat center center fixed;
        z-index:-1;
    }
    </style>
</head>
<body>
</body>
</html>
<?php }} ?>
