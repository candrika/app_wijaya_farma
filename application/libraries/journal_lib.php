<?php if (!defined('BASEPATH')) exit('No direct script access allowed');

class journal_lib {
	
	function delete($idjournal){
		$CI = & get_instance();

		// $q = $CI->db->get('sales');
		// return $q->result_array()[0];

		$qunit = $CI->db->query("select idunit from journal where idjournal = $idjournal");
        if($qunit->num_rows()>0){
            $runit = $qunit->row();

                $CI->db->trans_begin();

                /*
                accounthistory tidak terlacak
                */

                $CI->db->where('idjournal',$idjournal);
                $CI->db->delete('accountlog');

                $q = $CI->db->get_where('journalitem',array('idjournal'=>$idjournal));
                foreach ($q->result() as $r) {
                    $qacc = $CI->db->query("select balance,idaccounttype from account where idaccount = ".$r->idaccount." and idunit = ".$runit->idunit." ")->row();
                    $current_balance = $qacc->balance;
                    $trx_amount = $r->debit == 0 ? $r->credit : $r->debit;

                    if($qacc->idaccounttype==1 || $qacc->idaccounttype==2 || $qacc->idaccounttype==3 || $qacc->idaccounttype==4 || $qacc->idaccounttype==5 || $qacc->idaccounttype==6 || $qacc->idaccounttype==11 || $qacc->idaccounttype==17 || $qacc->idaccounttype==19 || $qacc->idaccounttype==20 || $qacc->idaccounttype==21){
                        $newbalance = $current_balance + $trx_amount;
                    } else {
                        $newbalance = $current_balance - $trx_amount;
                    }

                    $CI->db->where(array(
                            'idaccount'=>$r->idaccount,
                            'idunit'=>$runit->idunit
                        ));
                    $CI->db->update('account',array(
                            'balance'=>$newbalance
                        ));
                }

                $CI->db->where('idjournal',$idjournal);
                $CI->db->delete('journalitem');

                $CI->db->where('idjournal',$idjournal);
                $CI->db->delete('journal');

                if ($CI->db->trans_status() === FALSE)
                {
                    $CI->db->trans_rollback();
                    $json = array('success'=>false,'message'=>'hapus jurnal gagal');
                }
                else
                {
                    $CI->db->trans_commit();
                    $json = array('success'=>true,'message'=>'hapus jurnal berhasil');
                }
                
                // echo json_encode($json);
                return $json;
        } else {
            $json = array('success'=>false,'message'=>'id journal tidak ditemukan');
            return $json;
            // echo json_encode($json);
            // exit();
        }
	}


}