BEGIN { 
	# variables for pdr calculation
        tahoe_sp = 0; 
        tahoe_rp = 0; 
        
        reno_sp = 0; 
        reno_rp = 0;
        
        vegas_sp = 0; 
        vegas_rp = 0;
        
        # variables for finding tput achieved 
        th_srt_time = 0;
        th_end_time = 0;
        th_flag = 0;
        th_dataRec = 0;  
        
        
        rn_srt_time = 0;
        rn_end_time = 0;
        rn_flag = 0;
        rn_dataRec = 0;
        
        vg_srt_time = 0;
        vg_end_time = 0;
        vg_flag = 0;
        vg_dataRec = 0;
        
        
        # variables for finding average e2e delay
        th_num_samples = 0;
	th_total_delay = 0;
	 
        rn_num_samples = 0;
	rn_total_delay = 0;
	 
        vg_num_samples = 0;
	vg_total_delay = 0 ; 
        
   
} 

{
	if (($1 == "s") && ($2 <= 63.0) && ($3 == "_7_") && ($4 == "AGT") && ($7 == "tcp"))
	{ 
	   	tahoe_sp++;	
	   
	   	if (th_flag == 0) 
		{
		  th_srt_time = $2;
		  th_flag = 1;
		}
		
		th_stime_arr[$6] = $2;
		th_end_time = $2;
	}
	
	if (($1 == "s") && ($2 <= 65.0) && ($3 == "_8_") && ($4 == "AGT") && ($7 == "tcp"))
	{ 
	   	reno_sp++;
	   		
	   	if (rn_flag == 0) 
		{
		  rn_srt_time = $2;
		  rn_flag = 1;
		}
		rn_end_time = $2;
		
		rn_stime_arr[$6] = $2
	}
	
	if (($1 == "s") && ($2 <= 66.0) && ($3 == "_9_") && ($4 == "AGT") && ($7 == "tcp"))
	{ 
	   	vegas_sp++;
	   	
	   	if (vg_flag == 0) 
		{
		  vg_srt_time = $2;
		  vg_flag = 1;
		}
	        vg_end_time = $2;
	        
	        vg_stime_arr[$6] = $2;	
	}
	
	
	if (($1 == "r") && ($2 <= 63.0) && ($3 == "_10_") && ($4 == "AGT") && ($7 == "tcp"))
	{ 
		   tahoe_rp++;	
		   
		   th_dataRec += $8; 
		   
		   if (th_stime_arr[$6] >= 0.0) {
				th_etime_arr[$6] = $2
				th_ind_delay = th_etime_arr[$6] - th_stime_arr[$6]
				th_total_delay += th_ind_delay
				th_num_samples += 1
		  }
	}
	
	if (($1 == "r") && ($2 <= 65.0) && ($3 == "_11_") && ($4 == "AGT") && ($7 == "tcp"))
	{ 
		   reno_rp++;
		   
		   rn_dataRec += $8;
		   
		   if (rn_stime_arr[$6] >= 0.0) {
				rn_etime_arr[$6] = $2
				rn_ind_delay = rn_etime_arr[$6] - rn_stime_arr[$6]
				rn_total_delay += rn_ind_delay
				rn_num_samples += 1
		  }	
	}
	
	if (($1 == "r") && ($2 <= 66.0) && ($3 == "_12_") && ($4 == "AGT") && ($7 == "tcp"))
	{ 
		   vegas_rp++;
		   
		   vg_dataRec += $8;
		   
		   if (vg_stime_arr[$6] >= 0.0) {
			vg_etime_arr[$6] = $2
			vg_ind_delay = vg_etime_arr[$6] - vg_stime_arr[$6]
			vg_total_delay += vg_ind_delay
			vg_num_samples += 1
		   }		
		   
	}
	
	
}

END { 

	printf("\tTransport Layer -----> TCP Tahoe\n\n");

	printf("Throughput Results : \n");
	delay = th_end_time-th_srt_time;
	tput  = (th_dataRec*8)/(delay*1000000);
	printf("Throughput Obtained = %f Mbps \n\n",tput);
	      
	printf("Packet Delivery Ratio Results : \n");
	printf("No of packets Sent 	 :   %d\n",tahoe_sp);
	printf("No of packets Recieved   :   %d\n",tahoe_rp);
	printf("No of packets dropped 	 :   %d\n",tahoe_sp-tahoe_rp);
	printf("Packet delivery Ratio	 :   %f\n",tahoe_rp/tahoe_sp);      

	avg_delay = th_total_delay/th_num_samples
	printf("\nCalculating end to end delay :\n")
	printf("Total End-to-End Delay = %f ms " ,th_total_delay*1000)
	printf("\nAverage End-to-End Delay = %f ms \n\n" ,avg_delay*1000)
	
	

	printf("\tTransport Layer -----> TCP Reno\n\n")
	
	printf("Throughput Results : \n");
	delay = rn_end_time-rn_srt_time;
	tput  = (rn_dataRec*8)/(delay*1000000);
	printf("Throughput Obtained = %f Mbps \n\n",tput);
	      
	printf("Packet Delivery Ratio Results : \n");
	printf("No of packets Sent 	 :   %d\n",reno_sp);
	printf("No of packets Recieved   :   %d\n",reno_rp);
	printf("No of packets dropped 	 :   %d\n",reno_sp-reno_rp);
	printf("Packet delivery Ratio	 :   %f\n",reno_rp/reno_sp);

	avg_delay = rn_total_delay/rn_num_samples
	printf("\nCalculating end to end delay:\n")
	printf("Total End-to-End Delay = %f ms " ,rn_total_delay*1000)
	printf("\nAverage End-to-End Delay = %f ms \n\n" ,avg_delay*1000)
	
	

	printf("\tTransport Layer -----> TCP Vegas\n\n") 
	 
	printf("Throughput Results : \n");
	delay = vg_end_time-vg_srt_time;
	tput  = (vg_dataRec*8)/(delay*1000000);
	printf("Throughput Obtained = %f Mbps \n\n",tput);
	      
	printf("Packet Delivery Ratio Results : \n");    
	printf("No of packets Sent 	 :   %d\n",vegas_sp);
	printf("No of packets Recieved   :   %d\n",vegas_rp);
	printf("No of packets dropped 	 :   %d\n",vegas_sp-vegas_rp);
	printf("Packet delivery Ratio	 :   %f\n",vegas_rp/vegas_sp);

	avg_delay = vg_total_delay/vg_num_samples
	printf("\nCalculating end to end delay:\n")
	printf("Total End-to-End Delay = %f ms " ,vg_total_delay*1000)
	printf("\nAverage End-to-End Delay = %f ms \n\n" ,avg_delay*1000)

         
}
