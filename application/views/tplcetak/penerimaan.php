<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><?=$title?></title>
    <link rel="stylesheet" href="<?=base_url()?>/assets/css/bootstrap.min.css">

    <style>
    /*  @import url(http://fonts.googleapis.com/css?family=Bree+Serif);
      body, h1, h2, h3, h4, h5, h6{
        font-family: 'Bree Serif', serif;
      }*/
    /*}*/
body {
    font-family: "Helvetica Neue",Helvetica,Arial,sans-serif;
    font-size: 12px;
    /* line-height: 1; */
    color: #333;
    background-color: #fff;
}
.table>tbody>tr>td, .table>tbody>tr>th, .table>tfoot>tr>td, .table>tfoot>tr>th, .table>thead>tr>td, .table>thead>tr>th {
    padding: 2px;
    line-height: 1.42857143;
    vertical-align: top;
    border-top: 1px solid #ddd;
}
.panel-heading {
    padding: 0px 0px 0px 0px;
    border-bottom: 1px solid transparent;
    border-top-left-radius: 3px;
    border-top-right-radius: 3px;
}
p {
    margin: 0 0 0px;
}
.borderless tbody tr td, .borderless tbody tr th, .borderless thead tr th {
border: none;
}
</style>
</head>
  <!-- <body> -->
  <body onload="window.print()">


    <div class="container">

      <div class="panel panel-info">
      <div class="panel-body">
      

    
      <div class="row">
        <div class="col-xs-6">
          <h1>
            <?=$this->logo?>
          </h1>
        </div>
        <div class="col-xs-6 text-right">
          <h2><?=$title?></h2>
          NO: #<?=$data['no']?><br>
          Tanggal: <?=$data['datetrans']?>
        </div>
      </div>
      
      <div class="row" style="margin-left:1px;">
        <address>
          <strong><?=$data['namaunit']?></strong><br>
          <?=$data['alamat']?>
        </address> 
      </div>
      
      <div class="row" style="margin-left:1px;">
        <table class="table borderless" >
          <?php
         if($data['namecustomer']!=''){
          ?>
           <tr>
           <td width="22%"><b> Konsumen:</b></td>
           <td width="50%"><?=$data['namecustomer']?></td>
         </tr>
           <?php
         }
         ?>
         <?php
         if($data['receivefrom']!=''){
          ?>
         <tr>
           <td width="22%"><b> Diterima Dari:</b></td>
           <td width="50%"><?=$data['receivefrom']?></td>
         </tr>
         <?php
         }
         ?>
         <tr>
           <td width="22%"><b>Akun Kas/Bank:</b></td>
           <td width="50%"><?=$data['accnumber']?> <?=$data['accname']?></td>
         </tr>
         <tr>
           <td width="22%"><b>Pembayaran:</b></td>
           <td width="50%"></td>
         </tr>
         <?php
         // echo $data['totaltax'];

              if($data['detail']!=null)
              {
              ?>
                      <table class="table table-bordered" style="width:99%; margin-left:1px; margin-right:2px;">
                        <tr>
                          <th width="30">No</th>                         
                          <th>No Akun</th>                      
                          <th>Nama Akun</th>
                           <?php
                          if($data['totaltax']!=0)
                          {
                            $colspan=3;
                            echo "<th>Pajak %</th>";
                          } else {
                             $colspan=3;
                          }
                          ?>
                          <th>Jumlah</th>
                        </tr>
                        <?php
                        // print_r($data['detail']);
                        $i=1;
                        foreach ($data['detail'] as $key => $value) {
                           ?>
                             <tr>
                              <td width="30"><?=$i?></td>
                              <td><?=$value['accnumber']?></td>
                              <td><?=$value['accname']?></td>
                              <?php
                              if($data['totaltax']!=0)
                              {
                                echo "<td>".$value['tax']."</td>";
                              }
                              ?>
                              <td align="right"><?=$value['jumlah']?></td>
                            </tr>
                           <?php
                           if($value['denda']!=null)
                           {
                            $i++;
                              ?>
                              <tr>
                                <td width="30"><?=$i?></td>
                                <td><?=$value['denda']['accname']?></td>
                                <?php
                                if($data['totaltax']!=0)
                                {
                                  echo "<td> </td>";
                                }
                                ?>
                                <td align="right"><?=$value['denda']['jumlah']?></td>
                              </tr>
                              <?php
                           }
                           $i++;
                          }
                        ?>
                       
                      </table>
              <?php
              }
              ?>

              <table class="table" style="width:99%; margin-top:-20px; margin-left:1px; margin-right:2px; border:0px;">
                  <tr>
                      <td></td>
                       <td> </td>
                      <td align="right"><b>Subtotal</b></td>
                      <td align="right" width="200"><?=$data['total']?></td>
                    </tr>
                 <?php
                    if($data['totaltax']!=0)
                    {
                      ?>
                    <tr>
                      <td></td>
                       <td> </td>
                      <td align="right"><b>Pajak (-)</b></td>
                      <td align="right"><?=number_format($data['totaltax'])?></td>
                    </tr>
                    <?php
                    }
                    ?>
                     <tr>
                      <td></td>
                       <td> </td>
                      <td align="right"><b>Total</b></td>
                      <td align="right" width="200"><?=$data['total']?></td>
                    </tr>
              </table>
         <tr>
           <td width="22%"><b> Memo:</b></td>
           <td width="50%"><?=$data['memo']?></td>
         </tr>
        </table>
      </div>
      
      <div class="row">
        <div class="col-xs-6">
          <b>Terbilang: </b><?=$data['terbilang']?>
        </div>
        <div class="col-xs-6 text-right">
        </div>
      </div>


      <p>&nbsp;</p>
      <div class="row">
        <div class="col-xs-4 ">
          <div class="panel panel-default">
            <div class="panel-heading">
              <p style="text-align: center;">Dibukukan Oleh</p>
            </div>
            <div class="panel-body">
              <br><br>
              <p>
              <center><?=$data['receivedby']?><center>
              </p>
            </div>
          </div>
        </div>
        <div class="col-xs-4 ">
          <div class="panel panel-default">
            <div class="panel-heading">
              <p style="text-align: center;">Disetujui oleh</p>
            </div>
            <div class="panel-body">
              <br><br><br>
              <p>
              <!-- <center>(______________________________) -->
            </div>
          </div>
        </div>
        <div class="col-xs-4 ">
          <div class="panel panel-default">
            <div class="panel-heading">
              <p style="text-align: center">Penerima</p>
            </div>
            <div class="panel-body">
            <br><br><br>
            <p>
            <!-- <center>(______________________________) -->
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
                    

          </div>
  </div> <!-- panel -->
  

    </div><!-- container -->


      
  </body>
</html>
