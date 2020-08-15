<?php

class m_sales extends CI_Model {


	function data($idsales=null,$idunit=null,$source=null,$stardate=null,$enddate=null,$option=null,$status=null,$is_order_request=null,$customer_type=null,$query=null){
		$wer = '';

		if($idunit!=null){
			$wer.=" AND a.idunit = $idunit ";
		}

		if($source!=null){
			$wer.=" AND a.source = $source ";
		}

		if($stardate!=null && $enddate!=null){
			$wer.=" AND (a.date_sales between '".$stardate."' and '".$enddate."') ";
		}

		if($idsales!=null && $idsales!=''){
			$wer.=" AND a.idsales = $idsales ";
		}

		if($option!=null){
			if($option=='unpaid'){
				$wer.=" AND (a.unpaid_amount != 0 and a.unpaid_amount >=0)";
			}			
		}
		
		if($status!=null && $status!=0){
			$wer.=" AND (a.invoice_status=$status OR a.status=$status)";
		}

		if($is_order_request!=null && $is_order_request=='true'){
			// echo "xxxx";
			$wer .= " AND a.date_quote is not null";
		}

		if($customer_type!=null && $customer_type!=0){
			$wer.=" AND a.customer_type=$customer_type";
		}

		if($query!=null){
			$wer.="AND ((f.member_name like '%".$query."%' OR f.member_name like '%".strtolower($query)."%' OR
						 	f.member_name like '%".ucwords($query)."%' OR f.member_name like '%".strtoupper($query)."%') OR 
						   (c.namecustomer like '%".$query."%' OR c.namecustomer like '%".strtolower($query)."%' OR c.namecustomer like '%".ucwords($query)."%' OR c.namecustomer like '%".strtoupper($query)."%'))";
			
		}

		$q = $this->db->query("select a.idsales,a.idpayment,a.noinvoice,a.tax_id,a.idcustomer,a.subtotal,a.freight,a.tax,a.disc,a.totalamount,a.paidtoday,a.unpaid_amount,a.comments,a.userin,a.datein,a.status,a.invoice_status,a.idunit,a.date_sales,a.no_sales_order,a.include_tax,a.total_dpp,a.pos_payment_type_id,a.id_member,
								b.namepayment,c.namecustomer,c.address as customer_address,c.email as customer_email,d.namaunit,e.payment_type_name,f.member_name,f.no_member,f.address,f.email,COALESCE(NULLIF(a.other_fee ,NULL) , 0 ) as other_fee,unpaid_amount,customer_type,a.due_date,a.memo,a.id_payment_term,g.term_name,a.total,a.order_status,a.payment_amount,a.change_amount
								from sales a
								left join payment b ON a.idpayment = b.idpayment
								left join customer c ON a.idcustomer = c.idcustomer
								join unit d ON a.idunit = d.idunit
								left join pos_payment_type e ON a.pos_payment_type_id = e.pos_payment_type_id
								left join member f ON a.id_member = f.id_member
								left join payment_term g ON a.id_payment_term = g.id_payment_term
								where true and (a.display is null or a.display = 1) $wer
								order by a.idsales desc");

		$r = $q->result_array();
		$data = array();
		$i=0;
		foreach ($r as $key => $value) {
			
			if($value['status']==null){
				//invoice status
				$value['status'] = $value['invoice_status'];
			}

			if($value['customer_type']==1){
				$value['buyer_name'] = $value['member_name'];
			} else {
				$value['buyer_name'] = $value['namecustomer'];
			}

			$data[$i] = $value;
			$i++;
		}
		return $data;
	}

	function return_data($sales_return_id,$idunit,$startdate,$enddate){
		$wer = '';

		if($sales_return_id!=null){
			$wer.=" AND a.sales_return_id = $sales_return_id ";
		}

		if($startdate!=null && $enddate!=null){
			$wer.=" AND (a.date_return between '".$startdate."' and '".$enddate."') ";
		}

		$q = $this->db->query("select a.sales_return_id,a.sales_id,a.status,a.memo,a.date_return,a.total_qty_return,a.total_amount_return,a.datein,a.userin,a.no_return,a.idunit,
								b.noinvoice,b.no_sales_order,b.date_sales,customer_type,c.namecustomer,f.member_name,f.no_member,a.memo,b.due_date,b.include_tax
								from sales_return a
								join sales b ON a.sales_id = b.idsales
								left join customer c ON b.idcustomer = c.idcustomer
								left join member f ON b.id_member = f.id_member
								where a.idunit = $idunit and a.deleted = 0 $wer
								order by a.sales_return_id desc");

		$r = $q->result_array();
		$data = array();
		$i=0;
		foreach ($r as $key => $value) {
			if($value['customer_type']==1){
				$value['buyer_name'] = $value['member_name'];
			} else {
				$value['buyer_name'] = $value['namecustomer'];
			}

			$data[$i] = $value;
			$i++;
		}
		return $data;
	}

	function return_item_data($sales_return_id,$idunit){
		$wer = " and a.sales_return_id = $sales_return_id";

		$q = $this->db->query("select a.sales_return_item_id,a.sales_return_id,a.sales_item_id,a.qty_sale,b.price,sum(b.price*a.qty_sale) as total,a.qty_retur,a.notes,a.datemod,c.product_name,c.product_no,b.description,sum(b.price*a.qty_retur) as total_amount_return
								from sales_return_item a 
								join salesitem b ON b.idsalesitem = a.sales_item_id
								join product c ON c.product_id = b.product_id
								where true $wer
								group by a.sales_return_item_id,b.price,c.product_name,c.product_no,b.description
								");
		$r = $q->result_array();
		$data = array();
		$i=0;
		foreach ($r as $key => $value) {
			$data[$i] = $value;
			$i++;
		}
		return $data;
	}

	function item_data($sales_id,$idunit,$except_id=null){
		$wer = null;

		if($except_id!=null){
	       
	        if(count($except_id)>0){
	            $wer = " and a.idsalesitem not IN (";
	            foreach ($except_id as $v) {
	                $wer.="$v,";
	            }
	            $wer = rtrim($wer,",");
	            $wer.= ")";
	        }
		}

		$q = $this->db->query("select a.idsalesitem,a.product_id,c.product_name,c.product_no,a.price,a.qty,a.total_tax,a.disc,a.total,a.description,c.no_sku,a.ratetax as rate
									from salesitem a
									join sales b ON a.idsales = b.idsales
									join product c ON a.product_id = c.product_id
									where a.idsales = $sales_id and b.idunit = $idunit $wer");
		$r = $q->result_array();
		$data = array();
		$i=0;
		foreach ($r as $key => $value) {
			$data[$i] = $value;
			$i++;
		}
		return $data;
	}

	function invoice_data($idunit=null,$idsales=null,$option=null,$stardate=null,$enddate=null,$status=null,$customer_type=null){
		$wer = '';

		if($idunit!=null){
			$wer.=" AND a.idunit = $idunit ";
		}

		if($idsales!=null){
			$wer.=" AND a.idsales = $idsales ";
		}

		if($option!=null){
			if($option=='unpaid'){
				$wer.=" AND a.unpaid_amount != 0 ";
			}			
		}

		if($status!=null && $status!=0){
			$wer.=" AND a.invoice_status = $status";
				
		}

		if($stardate!=null && $enddate!=null){
			$wer.=" AND (a.date_sales between '".$stardate."' and '".$enddate."') ";
		}

		if($customer_type !=null && $customer_type !=0){
			$wer.=" AND a.customer_type = $customer_type";
		}

		$q = $this->db->query("select a.idsales,a.idpayment,a.noinvoice,a.tax_id,a.idcustomer,a.subtotal,a.freight,a.tax,a.disc,a.totalamount,a.paidtoday,a.unpaid_amount,a.comments,a.userin,a.datein,a.status,a.idunit,a.date_sales,a.no_sales_order,a.include_tax,a.total_dpp,a.pos_payment_type_id,a.id_member,
								b.namepayment,c.namecustomer,d.namaunit,e.payment_type_name,COALESCE(NULLIF(f.member_name ,NULL) , 'Non Anggota' ) as member_name,f.no_member,COALESCE(NULLIF(a.other_fee ,NULL) , 0 ) as other_fee,unpaid_amount,a.invoice_date,a.due_date,a.invoice_status,
								case 
									when a.customer_type = 1 then member_name
									when a.customer_type = 2 then namecustomer
								end as customer_name
								from sales a
								left join payment b ON a.idpayment = b.idpayment
								left join customer c ON a.idcustomer = c.idcustomer
								join unit d ON a.idunit = d.idunit
								left join pos_payment_type e ON a.pos_payment_type_id = e.pos_payment_type_id
								left join member f ON a.id_member = f.id_member
								where true and (a.display is null or a.display = 1) and a.noinvoice is not null $wer
								order by a.idsales desc");

		return $q->result_array();
	}

	function where_sales_date($startdate=null,$enddate=null,$prefix=null){
		$wer_sales_date = null;
		if(($startdate!=null && $startdate!='') && ($enddate!=null && $enddate!='')){
			$add_prefix = null;
			if($prefix!=null){
				$add_prefix = " $prefix.";
			}
            $wer_sales_date = " and ($add_prefix"."date_sales between '".$startdate."' and '".$enddate."')";
        }

        return $wer_sales_date;
	}

	function summary($idunit,$startdate=null,$enddate=null){
		
		

		$q = $this->db->query("select count(*) as total_product
		from product
		where deleted = 0 and idunit = $idunit");
		if($q->num_rows()>0){
			$r = $q->result_array()[0];
			$total_product = $r['total_product'];
		} else {
			$total_product = 0;
		}

		$q2 = $this->db->query("select count(*) as total_qty_sales
							from salesitem a
							left join product b ON a.product_id = b.product_id
							join sales c ON a.idsales = c.idsales
							where (c.display != 0 OR display is null) and a.product_id is not null ".$this->where_sales_date($startdate,$enddate,'c')."
							and b.idunit = $idunit");
		if($q2->num_rows()>0){
			$r = $q2->result_array()[0];
			$total_qty_sales = $r['total_qty_sales'];
		} else {
			$total_qty_sales = 0;
		}

		// $q3 = $this->db->query("select COALESCE(NULLIF(sum(c.totalamount),null),0) as total_amount_sales
		// 			from salesitem a
		// 			left join product b ON a.product_id = b.product_id
		// 			join sales c ON a.idsales = c.idsales
		// 			where (c.display != 0 OR display is null) and a.product_id is not null and c.deleted = 0
		// 			and b.idunit = $idunit");
		$q3 = $this->db->query("select COALESCE(
										NULLIF(sum(totalamount), null),
										0
									) as total_amount_sales
								from sales 
								where idunit = $idunit and (status = 5 or invoice_status = 5) and display is null ".$this->where_sales_date($startdate,$enddate)." ");
		if($q3->num_rows()>0){
			$r = $q3->result_array()[0];
			$total_amount_sales = $r['total_amount_sales'];
		} else {
			$total_amount_sales = 0;
		}

		//sales today
		// $q4 = $this->db->query("select COALESCE(NULLIF(sum(c.totalamount),null),0) as total_amount_sales
		// 			from salesitemx a
		// 			left join product b ON a.product_id = b.product_id
		// 			join sales c ON a.idsales = c.idsales
		// 			where (c.display != 0 OR display is null) and a.product_id is not null 
		// 			and b.idunit = $idunit  and (a.datein BETWEEN '".date('Y-m-d')." 00:00:00' and '".date('Y-m-d')." 23:59:59') ");
		$q4 = $this->db->query("select COALESCE(
										NULLIF(sum(totalamount), null),
										0
									) as total_amount_sales
								from sales 
								where idunit = $idunit and display is null and (datein BETWEEN '".date('Y-m-d')." 00:00:00' and '".date('Y-m-d')." 23:59:59') ");
		if($q4->num_rows()>0){
			$r = $q4->result_array()[0];
			$total_sales_today = $r['total_amount_sales'];
		} else {
			$total_sales_today = 0;
		}

		//omzet
		$q4 = $this->db->query("select  COALESCE(NULLIF(total_omzet_nonmember,null),0) as total_omzet_nonmember,
										COALESCE(NULLIF(total_omzet_member,null),0) as total_omzet_member
								from (select sum(totalamount) as total_omzet_nonmember
									from sales
									where display is null and status = 5 ".$this->where_sales_date($startdate,$enddate)." and id_member is null and idunit = $idunit) a,
								(select sum(totalamount) as total_omzet_member
									from sales
									where (display is null OR display is null) and status = 5 ".$this->where_sales_date($startdate,$enddate)." and id_member is not null and idunit = $idunit) b");
		if($q4->num_rows()>0){
			$r = $q4->result_array()[0];
			$total_omzet_nonmember = $r['total_omzet_nonmember'];
			$total_omzet_member = $r['total_omzet_member'];
		} else {
			$total_omzet_nonmember = 0;
			$total_omzet_member = 0;
		}

		//start invoice
		$q = $this->db->query("select COALESCE(NULLIF(count(*),null),0) as total_invoice
								from sales
								where noinvoice is not null ".$this->where_sales_date($startdate,$enddate)." and (display is null) and idunit = $idunit")->row();
		$total_invoice = $q->total_invoice;

		$q = $this->db->query("select COALESCE(NULLIF(sum(paidtoday), null), 0) as total_paid,COALESCE(NULLIF(sum(unpaid_amount), null), 0) as unpaid_amount
								from sales
								where noinvoice is not null ".$this->where_sales_date($startdate,$enddate)." and (display is null) and idunit = $idunit")->row();
		$total_invoice_paid = $q->total_paid;
		$total_invoice_unpaid = $q->unpaid_amount;
		//end invoice

		//start sales sales_requisition
		$q5 = $this->db->query("select COALESCE(NULLIF(count(*),null),0) as total_sales_requisition
								from sales 
								where idunit = $idunit and display is null and order_status is not null and order_status !=0  ".$this->where_sales_date($startdate,$enddate)." and  (order_status !=6) and (order_status !=7)");
		if($q5->num_rows()>0){
			$r = $q5->result_array()[0];
			$total_sales_requisition = $r['total_sales_requisition'];
		} else {
			$total_sales_requisition = 0;
		}
		//end sales sales_requisition

		$data = array(
				'total_omzet_nonmember'=>intval($total_omzet_nonmember),
				'total_omzet_member'=>intval($total_omzet_member),
				'total_product'=>intval($total_product),
				'total_qty_sales'=>intval($total_qty_sales),
				'total_amount_sales'=>intval($total_amount_sales),
				'total_sales_today'=>intval($total_sales_today),
				'total_invoice'=>intval($total_invoice),
				'total_invoice_paid'=>intval($total_invoice_paid),
				'total_invoice_unpaid'=>intval($total_invoice_unpaid),
				'total_sales_requisition'=>$total_sales_requisition,
		);
		return $data;
	}

	function remove_return($id,$user_id){
		$this->db->trans_begin();
		$this->stock_after_return($id,$type=10);
		$this->db->where('sales_return_id',$id);
		$this->db->delete('sales_return_item');

		$this->db->where('sales_return_id',$id);
		$this->db->delete('sales_return');

		if($this->db->trans_status() === false){
            $this->db->trans_rollback();
            $json = array('success'=>false,'message'=>'Data retur gagal dihapus');
        }else{
            $this->db->trans_commit();
            $json = array('success'=>true,'message'=>'Data retur berhasil dihapus');
        }

        return $json;
	}

	function remove($id,$user_id){
		$sales_id = $id;

		$this->load->library('journal_lib');

		$q = $this->db->get_where('sales',array('idsales'=>$id));
		if($q->num_rows()>0){
			$r = $q->row();
			$idjournal = $r->idjournal;

			if($r->noinvoice!=null){
				//invoice
				$qsales = $this->db->get_where('sales_journal',array('idsales'=>$id));
				foreach ($qsales->result() as $r2) {
					// $this->m_journal->delete($r2->idjournal,$user_id);
					if($r2->idjournal!=null){
						$this->journal_lib->delete($r2->idjournal);
					}
				}

				$this->db->where('idsales',$id);
				$this->db->delete('sales_journal');
					
					$this->db->where(array('idsales'=>$id));
					$this->db->update('sales',array('display'=>0));
			} else {
				$this->db->where(array('idsales'=>$id));
				$this->db->update('sales',array('display'=>0));

				
			}
			
			if($idjournal!=null){
				$this->journal_lib->delete($idjournal);
			}
			$ret = array('success'=>true,'message'=>'sales data was removed'); 
		} else {
			$ret = array('success'=>false,'message'=>'failed while removing sales data'); 
		}

		return $ret;
	}

	function jurnal_sales($tgljournal,$memo,$totalamount,$idunit,$userid,$idsales=null){
		/*
			KAS (D)
			Penjualan (K)
		*/

		$this->db->trans_begin();

		$tgl = explode("-", $tgljournal);

        $idjournal = $this->m_data->getPrimaryID2(null,'journal', 'idjournal');

        $d = array(
            'idjournal' => $idjournal,
            'idjournaltype' => 3, //penjualan
            'nojournal' => 'SLS'.rand(11111,99999),
            'datejournal' => $tgljournal,
            'memo' => $memo,
            'totaldebit' => $totalamount,
            'totalcredit' => $totalamount,
            'year' => $tgl[0],
            'month' => $tgl[1],
            'userin' => $userid,
            'usermod' => $userid,
            'datein' => date('Y-m-d H:m:s'),
            'datemod' => date('Y-m-d H:m:s'),
            'idunit' => $idunit
        );

        $this->db->insert('journal', $d);	

		//KAS
		$amount = $totalamount;
		$idacc = $this->m_data->getIdAccount(9, $idunit);
		// echo $this->db->last_query();
		// $idacc = $idaccount_coa_kas;

		$curunpaid_balance2 = $this->m_account->getCurrBalance($idacc, $idunit,$userid);
		//itung saldo baru
		$newunpaid_balance2 = $curunpaid_balance2 + $amount;
		//insert
		$ditem2 = array(
		    'idjournal' => $idjournal,
		    'idaccount' => $idacc,
		    'debit' => $amount,
		    'credit' => 0,
		    'lastbalance' => $curunpaid_balance2,
		    'currbalance' => $newunpaid_balance2
		);
		$this->db->insert('journalitem', $ditem2);
		//update saldo baru
		$this->m_account->saveNewBalance($idacc, $newunpaid_balance2, $idunit,$userid);
		$this->m_account->saveAccountLog($idunit,$idacc,0,$amount,$tgljournal,$idjournal,$userid);

		//PENJUALAN
		if($idsales==null){
			$amount = $totalamount;
			$idacc = $this->m_data->getIdAccount(30, $idunit);
			$curunpaid_balance2 = $this->m_account->getCurrBalance($idacc, $idunit);
			//itung saldo baru
			$newunpaid_balance2 = $curunpaid_balance2 + $amount;
			//insert
			$ditem2 = array(
			    'idjournal' => $idjournal,
			    'idaccount' => $idacc,
			    'debit' => 0,
			    'credit' => $amount,
			    'lastbalance' => $curunpaid_balance2,
			    'currbalance' => $newunpaid_balance2
			);
			$this->db->insert('journalitem', $ditem2);
			//update saldo baru
			$this->m_account->saveNewBalance($idacc, $newunpaid_balance2, $idunit,$userid);
			$this->m_account->saveAccountLog($idunit,$idacc,$amount,0,$tgljournal,$idjournal,$userid);
		} else {
			 $q = $this->db->query("select sum((a.total-COALESCE(NULLIF(a.total_tax ,NULL),0))) as total_sales,b.coa_sales_id,c.accname
								from salesitem a
								join product b ON a.product_id = b.product_id
								join account c ON b.coa_sales_id = c.idaccount and c.idunit = b.idunit
								where idsales = $idsales
								group by b.coa_sales_id,c.accname");
	        foreach ($q->result() as $r) {
	        	$idaccount = $r->coa_sales_id;
		        $amount = $r->total_sales;
		        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
		        $newBalanceK = $curBalanceK + $amount;

		        $ditem = array(
		            'idjournal' => $idjournal,
		            'idaccount' => $idaccount,
		            'debit' => 0,
		            'credit' => $amount,
		            'lastbalance' => $curBalanceK,
		            'currbalance' => $newBalanceK
		        );
		        $this->db->insert('journalitem', $ditem);
		        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userid);
		        $this->m_account->saveAccountLog($idunit,$idaccount,$amount,0,$tgljournal,$idjournal,$userid);
	        }
		}


		if($this->db->trans_status() === false){
            $this->db->trans_rollback();
            $json = array('success'=>false,'message'=>$this->db->last_query());
        }else{
            $this->db->trans_commit();
            $json = array('success'=>true,'idjournal'=>$idjournal);
        }

        return $json;
	}

	function jurnal_sales_invoice_ppn_n_pph($date,$memo,$total_before_tax,$amount,$idunit,$userin,$sales_id=null,$tax_id=null,$noinvoice=null){

		/* penjualan dengan PPN + pph 23 -
										d			k
				piutang					5885	
				aset pph23				165	
				hutang ppn							550
				penjualan 							5500
		*/

      	$tgl = explode("-", $date);

      	$noinvoice = $noinvoice == null ? rand(11111,99999) : $noinvoice;
      	
        $idjournal = $this->m_data->getPrimaryID2(null,'journal', 'idjournal');

     

        //pajak summary
        $pajak_dimuka = 0;
        $pajak_hutang_ppn = 0;
        $total_piutang = $amount;
        if($tax_id!='' && $tax_id!=null){
        	$qtax = $this->m_tax->get($tax_id);
            if(isset($qtax['data'][0])){
            	$qtax = $qtax['data'][0];

            	//hitung total penjualan dengan pajak di kredit/ppn dulu
			    $total_sales = 0;
			    $q = $this->db->query("select sum((a.total-COALESCE(NULLIF(a.total_tax ,NULL),0))) as total_sales,b.coa_sales_id,c.accname
										from salesitem a
										join product b ON a.product_id = b.product_id
										join account c ON b.coa_sales_id = c.idaccount and c.idunit = b.idunit
										where idsales = $sales_id
										group by b.coa_sales_id,c.accname");
			    foreach ($q->result() as $r) {
			    	$tax_amount = 0;
			    	if($qtax['is_tax_ppn']==1 && $qtax['is_tax_pph23']==1){
			        	$tax_amount = $r->total_sales*($qtax['coa_ppn_rate']/100);
			        }
			        // $total_sales += $r->total_sales+$tax_amount;
			        $total_sales += $r->total_sales;
			    }
			    //end hitung total penjualan
            	
            	$pajak_dimuka = $total_sales*($qtax['coa_pph23_rate']/100);
            	$pajak_hutang_ppn = $total_sales*($qtax['coa_ppn_rate']/100);

            	// echo $total_sales.' '.$pajak_dimuka.' '.$pajak_hutang_ppn;
            }
        }       
        //end pajak summary
      
    	$total_piutang = $total_sales+$pajak_hutang_ppn-$pajak_dimuka;
    	// echo $total_sales.'+'.$pajak_hutang_ppn.'-'.$pajak_dimuka;
    	// echo $total_piutang;
    	$total_amount = ($total_piutang+$pajak_dimuka);


        $d = array(
            'idjournal' => $idjournal,
            'idjournaltype' => 10, //piutang
            'nojournal' => $noinvoice,
//                    name character varying(225),
            'datejournal' => $date,
            'memo' => $memo,
            'totaldebit' => $total_amount,
            'totalcredit' => $total_amount,
//                    'totaltax' double precision,
//                    isrecuring boolean,
            'year' => $tgl[0],
            'month' => $tgl[1],
//                    display integer,
            'userin' => $userin,
            'usermod' =>$userin,
            'datein' => date('Y-m-d H:m:s'),
            'datemod' => date('Y-m-d H:m:s'),
            'idunit' => $idunit
        );
        $this->db->insert('journal', $d);

        //piutang 
        $idaccount = $this->m_data->getIdAccount(24, $idunit);
        $curBalanceD = $this->m_account->getCurrBalance($idaccount, $idunit);
        $newBalanceD = $curBalanceD + $total_piutang;
        $ditem = array(
            'idjournal' => $idjournal,
            'idaccount' => $idaccount,
            'debit' => $total_piutang,
            'credit' => 0,
            'lastbalance' => $curBalanceD,
            'currbalance' => $newBalanceD
        );
        $this->db->insert('journalitem', $ditem);
        $this->m_account->saveNewBalance($idaccount, $newBalanceD, $idunit,$userin);
        $this->m_account->saveAccountLog($idunit,$idaccount,0,$total_piutang,$date,$idjournal,$userin);


        //PAJAK
        $total_tax = 0;

        if($pajak_dimuka!=0){
        	$idaccount = $qtax['coa_pph23_sales_id'];
        	$total_tax+= $pajak_dimuka;
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK - $pajak_dimuka;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => $pajak_dimuka,
	            'credit' => 0,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,0,$pajak_dimuka,$date,$idjournal,$userin);
        }
        //END pajak_dimuka

        //PAJAK pajak_hutang_ppn
        if($pajak_hutang_ppn!=0){
        	$idaccount = $qtax['coa_ppn_sales_id'];
        	$total_tax+= $pajak_hutang_ppn;
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK + $pajak_hutang_ppn;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => 0,
	            'credit' => $pajak_hutang_ppn,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,$pajak_hutang_ppn,0,$date,$idjournal,$userin);
        }
        //END pajak_hutang_ppn

        //penjualan - credit
        //coa from produk
        $q = $this->db->query("select sum((a.total-COALESCE(NULLIF(a.total_tax ,NULL),0))) as total_sales,b.coa_sales_id,c.accname
								from salesitem a
								join product b ON a.product_id = b.product_id
								join account c ON b.coa_sales_id = c.idaccount and c.idunit = b.idunit
								where idsales = $sales_id
								group by b.coa_sales_id,c.accname");
        foreach ($q->result() as $r) {
        	$tax_amount = 0;

        	if($qtax['is_tax_ppn']==1 && $qtax['is_tax_pph23']==1){
            	$tax_amount = $r->total_sales*($qtax['coa_ppn_rate']/100);
	        }

        	$idaccount = $r->coa_sales_id;
	        // $amount = $r->total_sales+$tax_amount;
	        $amount = $r->total_sales;
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK + $amount;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => 0,
	            'credit' => $amount,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,$amount,0,$date,$idjournal,$userin);
        }
       

        return $idjournal;
    }

	function jurnal_sales_invoice_pph($date,$memo,$total_before_tax,$amount,$idunit,$userin,$sales_id=null,$tax_id=null,$noinvoice=null){

		/* penjualan dengan pph 23 -		
										d		k
			piutang						980	
			aset pajak dibayar dimuka	 20	
			penjualan 							1000
		*/

      	$tgl = explode("-", $date);

      	//CALCULATE PAJAK
        //PAJAK
        $total_tax = 0;

        if($tax_id!='' && $tax_id!=null){
        	$qtax = $this->m_tax->get($tax_id);
            if(isset($qtax['data'][0])){
            	$qtax = $qtax['data'][0];

                if($qtax['is_tax_ppn']==0 && $qtax['is_tax_pph23']==1){
        	 		//PPH SAJA 
        	 		$idaccount_tax = $qtax['coa_pph23_sales_id'];
                	$tax_amount = $total_before_tax*($qtax['coa_pph23_rate']/100);
		        	$total_tax+= $tax_amount;
                }
            }
        }
        //END PAJAK

      	$after_tax = $total_before_tax - $total_tax;

      	$noinvoice = $noinvoice == null ? rand(11111,99999) : $noinvoice;
      	
        $idjournal = $this->m_data->getPrimaryID2(null,'journal', 'idjournal');

        $d = array(
            'idjournal' => $idjournal,
            'idjournaltype' => 10, //piutang
            'nojournal' => $noinvoice,
//                    name character varying(225),
            'datejournal' => $date,
            'memo' => $memo,
            'totaldebit' => $amount,
            'totalcredit' => $amount,
//                    'totaltax' double precision,
//                    isrecuring boolean,
            'year' => $tgl[0],
            'month' => $tgl[1],
//                    display integer,
            'userin' => $userin,
            'usermod' =>$userin,
            'datein' => date('Y-m-d H:m:s'),
            'datemod' => date('Y-m-d H:m:s'),
            'idunit' => $idunit
        );
        $this->db->insert('journal', $d);

        //piutang 
        $idaccount = $this->m_data->getIdAccount(24, $idunit);
        $curBalanceD = $this->m_account->getCurrBalance($idaccount, $idunit);
        $newBalanceD = $curBalanceD + $after_tax;
        $ditem = array(
            'idjournal' => $idjournal,
            'idaccount' => $idaccount,
            'debit' => $after_tax,
            'credit' => 0,
            'lastbalance' => $curBalanceD,
            'currbalance' => $newBalanceD
        );
        $this->db->insert('journalitem', $ditem);
        $this->m_account->saveNewBalance($idaccount, $newBalanceD, $idunit,$userin);
        $this->m_account->saveAccountLog($idunit,$idaccount,0,$after_tax,$date,$idjournal,$userin);


        //PAJAK
        if($total_tax>0){
        	$idaccount = $idaccount_tax;
        	$curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK - $tax_amount;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => $tax_amount,
	            'credit' => 0,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,0,$tax_amount,$date,$idjournal,$userin);
        }
        //endpajak

        //penjualan - credit
        //coa from produk
        $q = $this->db->query("select sum((a.total-COALESCE(NULLIF(a.total_tax ,NULL),0))) as total_sales,b.coa_sales_id,c.accname
								from salesitem a
								join product b ON a.product_id = b.product_id
								join account c ON b.coa_sales_id = c.idaccount and c.idunit = b.idunit
								where idsales = $sales_id
								group by b.coa_sales_id,c.accname");
        foreach ($q->result() as $r) {
        	$tax_amount = 0;

        	if($qtax['is_tax_ppn']==0 && $qtax['is_tax_pph23']==1){
    	 		//PPH SAJA 
            	$tax_amount = $r->total_sales*($qtax['coa_pph23_rate']/100);
	        }

        	$idaccount = $r->coa_sales_id;
	        // $amount = $r->total_sales+$tax_amount;
	        $amount = $r->total_sales;
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK + $amount;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => 0,
	            'credit' => $amount,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,$amount,0,$date,$idjournal,$userin);
        }
       

        return $idjournal;
    }

    function jurnal_sales_invoice_notax($date,$memo,$total_before_tax,$amount,$idunit,$userin,$sales_id=null,$noinvoice=null){
      	$tgl = explode("-", $date);
      	
        $idjournal = $this->m_data->getPrimaryID2(null,'journal', 'idjournal');

        $noinvoice = $noinvoice == null ? rand(11111,99999) : $noinvoice;

        $d = array(
            'idjournal' => $idjournal,
            'idjournaltype' => 10, //piutang
            'nojournal' => $noinvoice,
//                    name character varying(225),
            'datejournal' => $date,
            'memo' => $memo,
            'totaldebit' => $amount,
            'totalcredit' => $amount,
//                    'totaltax' double precision,
//                    isrecuring boolean,
            'year' => $tgl[0],
            'month' => $tgl[1],
//                    display integer,
            'userin' => $userin,
            'usermod' =>$userin,
            'datein' => date('Y-m-d H:m:s'),
            'datemod' => date('Y-m-d H:m:s'),
            'idunit' => $idunit
        );
        $this->db->insert('journal', $d);

        //piutang 
        $idaccount = $this->m_data->getIdAccount(24, $idunit);
        $curBalanceD = $this->m_account->getCurrBalance($idaccount, $idunit);
        $newBalanceD = $curBalanceD + $amount;
        $ditem = array(
            'idjournal' => $idjournal,
            'idaccount' => $idaccount,
            'debit' => $amount,
            'credit' => 0,
            'lastbalance' => $curBalanceD,
            'currbalance' => $newBalanceD
        );
        $this->db->insert('journalitem', $ditem);
        $this->m_account->saveNewBalance($idaccount, $newBalanceD, $idunit,$userin);
        $this->m_account->saveAccountLog($idunit,$idaccount,0,$amount,$date,$idjournal,$userin);



        //penjualan - credit
        //coa from produk
        $q = $this->db->query("select sum((a.total-COALESCE(NULLIF(a.total_tax ,NULL),0))) as total_sales,b.coa_sales_id,c.accname
								from salesitem a
								join product b ON a.product_id = b.product_id
								join account c ON b.coa_sales_id = c.idaccount and c.idunit = b.idunit
								where idsales = $sales_id
								group by b.coa_sales_id,c.accname");
        foreach ($q->result() as $r) {
        	$tax_amount = 0;

        	$idaccount = $r->coa_sales_id;
	        $amount = $r->total_sales-$tax_amount;
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK + $amount;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => 0,
	            'credit' => $amount,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,$amount,0,$date,$idjournal,$userin);
        }
       

        return $idjournal;
    }

	function jurnal_sales_invoice_ppn($date,$memo,$total_before_tax,$amount,$idunit,$userin,$sales_id=null,$tax_id=null,$noinvoice=null,$include_tax=null){
      	$tgl = explode("-", $date);
      	
        $idjournal = $this->m_data->getPrimaryID2(null,'journal', 'idjournal');

        $noinvoice = $noinvoice == null ? rand(11111,99999) : $noinvoice;

        //PAJAK
        $total_tax = 0;

        if($tax_id!='' && $tax_id!=null){
        	$qtax = $this->m_tax->get($tax_id);
            if(isset($qtax['data'][0])){
            	$qtax = $qtax['data'][0];
        	 	if($qtax['is_tax_ppn']==1 && $qtax['is_tax_pph23']==0){
        	 		//PPN SAJA 
                    	$idaccount = $qtax['coa_ppn_sales_id'];
                    	$tax_amount = $total_before_tax*($qtax['coa_ppn_rate']/100);
			        	$total_tax+= $tax_amount;
                }
            }
        }
        //END PAJAK

     	if($include_tax==1){
        	//include tax kurangin piutang dan penjualan
     		// $amount+=$total_tax;
        } else {
        	// $amount+=$total_tax;
        }

        $d = array(
            'idjournal' => $idjournal,
            'idjournaltype' => 10, //piutang
            'nojournal' => $noinvoice,
//                    name character varying(225),
            'datejournal' => $date,
            'memo' => $memo,
            'totaldebit' => $amount,
            'totalcredit' => $amount,
//                    'totaltax' double precision,
//                    isrecuring boolean,
            'year' => $tgl[0],
            'month' => $tgl[1],
//                    display integer,
            'userin' => $userin,
            'usermod' =>$userin,
            'datein' => date('Y-m-d H:m:s'),
            'datemod' => date('Y-m-d H:m:s'),
            'idunit' => $idunit
        );
        $this->db->insert('journal', $d);

        //piutang 
        $idaccount = $this->m_data->getIdAccount(24, $idunit);
        $curBalanceD = $this->m_account->getCurrBalance($idaccount, $idunit);
        $newBalanceD = $curBalanceD + $amount;
        $ditem = array(
            'idjournal' => $idjournal,
            'idaccount' => $idaccount,
            'debit' => $amount,
            'credit' => 0,
            'lastbalance' => $curBalanceD,
            'currbalance' => $newBalanceD
        );
        $this->db->insert('journalitem', $ditem);
        $this->m_account->saveNewBalance($idaccount, $newBalanceD, $idunit,$userin);
        $this->m_account->saveAccountLog($idunit,$idaccount,0,$amount,$date,$idjournal,$userin);


        //PAJAK - credit
        //PPN SAJA     
       	if($total_tax>0){
       		$idaccount = $qtax['coa_ppn_sales_id'];
        	$tax_amount = $total_before_tax*($qtax['coa_ppn_rate']/100);
        	$total_tax+= $tax_amount;
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK + $tax_amount;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => 0,
	            'credit' => $tax_amount,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,$tax_amount,0,$date,$idjournal,$userin);
       	}
        	
        //END PAJAK

       

        //penjualan - credit
        //coa from produk
        $q = $this->db->query("select sum((a.total-COALESCE(NULLIF(a.total_tax ,NULL),0))) as total_sales,b.coa_sales_id,c.accname
								from salesitem a
								join product b ON a.product_id = b.product_id
								join account c ON b.coa_sales_id = c.idaccount and c.idunit = b.idunit
								where idsales = $sales_id
								group by b.coa_sales_id,c.accname");
        foreach ($q->result() as $r) {

        	$idaccount = $r->coa_sales_id;

        	if($include_tax==1){
	        	//include tax kurangin piutang dan penjualan
     		 	$amount = $r->total_sales-$tax_amount;
	        } else {
	        	$amount = $r->total_sales;
	        }
	       
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK + $amount;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => 0,
	            'credit' => $amount,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,$amount,0,$date,$idjournal,$userin);
        }
       

        return $idjournal;
    }

    function jurnal_sales_invoice($date,$memo,$amount,$idunit,$userin,$sales_id=null){
      	$tgl = explode("-", $date);
      	
        $idjournal = $this->m_data->getPrimaryID2(null,'journal', 'idjournal');

        $d = array(
            'idjournal' => $idjournal,
            'idjournaltype' => 10, //piutang
            'nojournal' => rand(11111,99999),
//                    name character varying(225),
            'datejournal' => $date,
            'memo' => $memo,
            'totaldebit' => $amount,
            'totalcredit' => $amount,
//                    'totaltax' double precision,
//                    isrecuring boolean,
            'year' => $tgl[0],
            'month' => $tgl[1],
//                    display integer,
            'userin' => $userin,
            'usermod' =>$userin,
            'datein' => date('Y-m-d H:m:s'),
            'datemod' => date('Y-m-d H:m:s'),
            'idunit' => $idunit
        );
        $this->db->insert('journal', $d);

        //piutang 
        $idaccount = $this->m_data->getIdAccount(24, $idunit);
        $curBalanceD = $this->m_account->getCurrBalance($idaccount, $idunit);
        $newBalanceD = $curBalanceD + $amount;
        $ditem = array(
            'idjournal' => $idjournal,
            'idaccount' => $idaccount,
            'debit' => $amount,
            'credit' => 0,
            'lastbalance' => $curBalanceD,
            'currbalance' => $newBalanceD
        );
        $this->db->insert('journalitem', $ditem);
        $this->m_account->saveNewBalance($idaccount, $newBalanceD, $idunit,$userin);
        $this->m_account->saveAccountLog($idunit,$idaccount,0,$amount,$date,$idjournal,$userin);

        //hutang pajak - credit
        // https://www.online-pajak.com/jurnal-ppn
        $qtax = $this->db->query("select c.coa_ap_id,sum(total_tax) as total_tax,c.nametax
									from salesitem a
									join sales b ON a.idsales = b.idsales
									join tax c ON a.ratetax = c.rate and c.idunit = b.idunit and c.deleted = 0
									where a.idsales = $sales_id and a.ratetax!=0
									GROUP BY c.coa_ap_id,c.nametax");
        $total_tax =0;
        foreach ($qtax->result() as $r) {
        	$idaccount = $r->coa_ap_id;
        	// $amount = $r->total_tax;
        	$total_tax+=$r->total_tax;
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK + $r->total_tax;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => 0,
	            'credit' => $r->total_tax,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,$r->total_tax,0,$date,$idjournal,$userin);
        }

        //penjualan - credit
        // $idaccount = $this->m_data->getIdAccount(30, $idunit);
        // $amount = $amount-$total_tax;
        // $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
        // $newBalanceK = $curBalanceK + $amount;

        // $ditem = array(
        //     'idjournal' => $idjournal,
        //     'idaccount' => $idaccount,
        //     'debit' => 0,
        //     'credit' => $amount,
        //     'lastbalance' => $curBalanceK,
        //     'currbalance' => $newBalanceK
        // );
        // $this->db->insert('journalitem', $ditem);
        // $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
        // $this->m_account->saveAccountLog($idunit,$idaccount,$amount,0,$date,$idjournal,$userin);
        //coa from produk
        $q = $this->db->query("select sum((a.total-COALESCE(NULLIF(a.total_tax ,NULL),0))) as total_sales,b.coa_sales_id,c.accname
								from salesitem a
								join product b ON a.product_id = b.product_id
								join account c ON b.coa_sales_id = c.idaccount and c.idunit = b.idunit
								where idsales = $sales_id
								group by b.coa_sales_id,c.accname");
        foreach ($q->result() as $r) {
        	$idaccount = $r->coa_sales_id;
	        $amount = $r->total_sales;
	        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
	        $newBalanceK = $curBalanceK + $amount;

	        $ditem = array(
	            'idjournal' => $idjournal,
	            'idaccount' => $idaccount,
	            'debit' => 0,
	            'credit' => $amount,
	            'lastbalance' => $curBalanceK,
	            'currbalance' => $newBalanceK
	        );
	        $this->db->insert('journalitem', $ditem);
	        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
	        $this->m_account->saveAccountLog($idunit,$idaccount,$amount,0,$date,$idjournal,$userin);
        }
       

        return $idjournal;
    }

    function jurnal_sales_payment($date,$memo,$amount,$idunit,$userin,$coa_debit,$coa_credit){
    	$tgl = explode("-", $date);

    	$idjournal = $this->m_data->getPrimaryID2(null,'journal', 'idjournal');

        $d = array(
            'idjournal' => $idjournal,
            'idjournaltype' => 10, //piutang
            'nojournal' => rand(11111,99999),
//                    name character varying(225),
            'datejournal' => $date,
            'memo' => $memo,
            'totaldebit' => $amount,
            'totalcredit' => $amount,
//                    'totaltax' double precision,
//                    isrecuring boolean,
            'year' => $tgl[0],
            'month' => $tgl[1],
//                    display integer,
            'userin' => $userin,
            'usermod' =>$userin,
            'datein' => date('Y-m-d H:m:s'),
            'datemod' => date('Y-m-d H:m:s'),
            'idunit' => $idunit
        );
        $this->db->insert('journal', $d);

        //debit - kas / bank
        $idaccount = $coa_debit;
        $curBalanceD = $this->m_account->getCurrBalance($idaccount, $idunit);
        $newBalanceD = $curBalanceD - $amount;
        $ditem = array(
            'idjournal' => $idjournal,
            'idaccount' => $idaccount,
            'debit' => $amount,
            'credit' => 0,
            'lastbalance' => $curBalanceD,
            'currbalance' => $newBalanceD
        );
        $this->db->insert('journalitem', $ditem);
        $this->m_account->saveNewBalance($idaccount, $newBalanceD, $idunit,$userin);
        $this->m_account->saveAccountLog($idunit,$idaccount,0,$amount,$date,$idjournal,$userin);

        //credit - piutang
        $idaccount = $coa_credit;
        $curBalanceK = $this->m_account->getCurrBalance($idaccount, $idunit);
        $newBalanceK = $curBalanceK - $amount;

        $ditem = array(
            'idjournal' => $idjournal,
            'idaccount' => $idaccount,
            'debit' => 0,
            'credit' => $amount,
            'lastbalance' => $curBalanceK,
            'currbalance' => $newBalanceK
        );
        $this->db->insert('journalitem', $ditem);
        $this->m_account->saveNewBalance($idaccount, $newBalanceK, $idunit,$userin);
        $this->m_account->saveAccountLog($idunit,$idaccount,$amount,0,$date,$idjournal,$userin);

        return $idjournal;
    }

    function save_return($sales_return_id,$sales_id,$data_item){
    	



    }

    function stock_after_return($id,$type){
        $this->db->trans_begin();
        
        $return_info = $this->db->query("select a.sales_return_item_id,a.sales_return_id,a.sales_item_id,b.product_id,a.qty_sale,a.qty_retur from sales_return_item a
                                         join salesitem b on b.idsalesitem=a.sales_item_id where a.sales_return_id=$id");
        
        foreach ($return_info->result() as $key => $v) {
              # code...

            $product_info = $this->db->get_where('product', array('product_id' =>$v->product_id))->result();
                
            $product_name = $product_info[0]->product_name;
        
            $params = array(
                  'idunit' => $this->user_data->idunit,
                  'prefix' => 'STCK',
                  'table' => 'stock_history',
                  'fieldpk' => 'stock_history_id',
                  'fieldname' => 'no_transaction',
                  'extraparams'=> null,
            );

            $notrx = $this->m_data->getNextNoArticle($params);
            
            if($type==6){

                $type_adjustment = $type;
                $trx_qty         = $v->qty_retur;
                $new_stock       = $product_info[0]->stock_available+$v->qty_retur;
            }else if($type==10){
                
                $type_adjustment = $type;
                $trx_qty         = $v->qty_retur;
                $new_stock       = $product_info[0]->stock_available-$v->qty_retur;
            }

            $data_stock=array(
                'stock_history_id'=>$this->m_data->getPrimaryID2(null,'stock_history','stock_history_id'),
                'product_id'=>$v->product_id,
                'type_adjustment'=>$type_adjustment,
                'no_transaction'=>$notrx,
                'datein'=>date('Y-m-d H:i'),
                'current_qty'=>$product_info[0]->stock_available,
                'trx_qty'=>$trx_qty,
                'new_qty'=>$new_stock
            );

            // die();
            //insert stock historis
            $this->db->insert('stock_history',$data_stock); 
            //end insert


            //update stock available 
            $this->db->where('product_id',$v->product_id);
            $this->db->update('product',array(
                'stock_available'=>$new_stock
            ));
            //end update 

        }  

        if($this->db->trans_status()===false){
            $this->db->trans_rollback();
        }else{
            $this->db->trans_commit();
        }
    }

    function data_sales_perpoduct($startdate=null,$enddate=null){

    	$wer ='';

    	if($startdate!=null && $enddate!=null){
    		$wer.=" and (c.date_sales BETWEEN '".$startdate."' and '".$enddate."')";
    	}

    	$q = $this->db->query("select a.product_name,a.no_sku,a.retail_price,a.retail_price_member,sum(b.qty) as qty ,sum(b.total) as total from product a
							   join salesitem b ON b.product_id=a.product_id
							   join sales c ON c.idsales=b.idsales
							   where a.idunit=".$this->user_data->idunit." and (c.display is null or c.display=1) and TRUE $wer
							   group by a.product_id");

    	$data=[];
    	$i=0;
    	foreach ($q->result_array() as $key => $value) {
    		# code...
    		$data[$i]=$value;
    		$i++;	
    	}

    	return $data;
    }

    function data_sales_aging($startdate=null,$enddate=null){

    	$wer =' TRUE and a.idunit='.$this->user_data->idunit.' and (a.display is null or a.display = 1)';

    	if($startdate!=null && $enddate!=null){
    		$wer.=" and (a.date_sales BETWEEN '".$startdate."' and '".$enddate."')";
    	}

    	$q = $this->db->query("SELECT 
    								c.namecustomer,d.member_name,a.status,a.customer_type,
    								sum (a.totalamount)  as total, e.term_name, sum (a.paidtoday) as paidtoday,
    								sum (a.unpaid_amount) as  unpaid_amount, a.date_sales,a.due_date
    							FROM 
    								sales a
							   JOIN 
							   		unit b on b.idunit=a.idunit
							   LEFT JOIN 
							   		customer c on c.idcustomer=a.idcustomer
							   LEFT JOIN 
							   		member d on d.id_member=a.id_member
							   JOIN 
							   		payment_term e on e.id_payment_term=a.id_payment_term
							   WHERE 
							   		$wer		
							   GROUP BY 
							   		c.idcustomer,d.id_member,e.id_payment_term,a.status,a.customer_type,a.customer_type,c.namecustomer,a.date_sales,a.due_date
							");

    	$data=[];
    	$i=0;
    	foreach ($q->result_array() as $key => $value) {
    		# code..

			if($value['customer_type']==1){
				$value['buyer_name'] = $value['member_name'];
			} else {
				$value['buyer_name'] = $value['namecustomer'];
			}

    		$data[$i]=$value;
    		$i++;	
    	}	

    	return $data;
    }

    function ar_by_product($startdate=null,$enddate=null){
    	$wer ='';

    	if($startdate!=null && $enddate!=null){
    		$wer.=" and (b.date_sales BETWEEN '".$startdate."' and '".$enddate."')";
    	}

    	$q = $this->db->query("select product_name,no_sku,total_unpaid
								from (select c.product_id,sum(a.total) as total_unpaid
									from salesitem a
									join product c ON a.product_id = c.product_id
									join sales b ON a.idsales = b.idsales
									where c.idunit = ".$this->user_data->idunit."  and b.invoice_status = 3 $wer
									group by c.product_id) a 
								join product b ON a.product_id = b.product_id");
    	$data = $q->result_array();
    	return $data;
    }

}

?>