<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Login extends MY_Controller {

	public function index()
	{
		$this->smarty->assign('msg','');
        $this->smarty->display('login.tpl');
	}

	
	function auth(){

		$response = $this->rest_client->request('POST', 'user/login',[
			'auth' => ['17091945',''],
			'form_params' => ['userid' => $this->input->post('userid'), 'password' => $this->input->post('password')],
			'http_errors' => false
		]);

		$code = $response->getStatusCode();
		$body = json_decode($response->getBody()->getContents());

		$code = $response->getStatusCode();
		
		if($code==200){
		
			$body = json_decode($response->getBody());
			// print_r($body);
			if($body->{'success'}==(bool)true){
				$this->session->set_userdata((array)$body->data);
				echo json_encode($body);	

			}else{

				echo json_encode($body);
			}
			
		} else {
			echo json_encode(array('success'=>false,'message'=>'Failed while connecting server ('.$code.')'));
		}
	}
}
