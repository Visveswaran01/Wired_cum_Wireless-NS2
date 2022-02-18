import matplotlib.pyplot as plt

class DataPlotter:
    """ This Class is created for plotting the graph between Network Parameters """
    
    font1 = {'family':'serif','color':'indigo','size':20}
    font2 = {'family':'serif','color':'darkred','size':18}
    
    def cwndPlot(self,file,algo_name):
        """ For PLotting the congestion window for 3 different Congestion Algorithms """
        
        xpoints  = []
        ypoints  = []
        
        with open(file,'r') as fp:
             for i in fp:
                 z = i.split()
                 if(float(z[0]) < 68.0):
                     xpoints.append(float(z[0]))
                     ypoints.append(float(z[1]))
        
        plt.plot(xpoints, ypoints,color = "red",linewidth = 1.5,linestyle = '-')
        ax = plt.axes()
        ax.patch.set_facecolor('khaki')
        heading = "Congestion Window Size in TCP " + algo_name
        plt.title(heading,fontdict=self.font1,fontweight='bold')
        
        plt.xlabel("Time",labelpad=10,fontdict=self.font2)
        plt.ylabel("cwnd (pkts)",labelpad=25,fontdict=self.font2)   
        
        plt.show()
    
    def tcp_tput(self,file,algo_name):
        
        """ For PLotting the Instantaneous Throughput for 3 different Congestion Algorithms """
        
        xpoints = []
        ypoints = []
        with open(file,'r') as fp:
            for i in fp:
                z = i.split()
                if (float(z[0]) >= 21.0 and float(z[0]) < 68.8):
                    xpoints.append(float(z[0]))
                    ypoints.append(float(z[1]))
                
        plt.plot(xpoints,ypoints,color="Crimson",linewidth=1.5,linestyle = '-')
        heading = "Instanteous Throughput of TCP " + algo_name
        plt.title(heading,fontdict=self.font1,fontweight='bold')
        plt.xlabel("Time",labelpad=10,fontdict=self.font2)
        plt.ylabel("Throughput (Mbps)",labelpad=25,fontdict=self.font2)
        plt.show()

    
    def udp_tput(self,file):
    
        """ For PLotting the Instantaneous Throughput for UDP Connection """
        
        xp1  = []
        xp2  = []
        xp3  = []
        
        yp1  = []
        yp2  = []
        yp3  = []
        
        #storing x and y points 
        with open(file,'r') as fp:
            for i in fp:
                z = i.split()
                
                if (float(z[0]) < 16.1):
                    xp1.append(float(z[0]))
                    yp1.append(float(z[1]))
                    
                elif (float(z[0]) >= 16.1 and float(z[0]) < 30.8):
                    xp2.append(float(z[0]))
                    yp2.append(float(z[1]))
                
                elif (float(z[0]) >= 30.8 and float(z[0]) <= 50.0):
                    xp3.append(float(z[0]))
                    yp3.append(float(z[1]))
                    
        plotdata = []
        plotdata.append((xp1,yp1,'MH in Home Agent'))
        plotdata.append((xp2,yp2,'MH is in out of coverage area'))
        plotdata.append((xp3,yp3,'MH  again in Home Agent'))
  
        
        for k in plotdata:
            plt.plot(k[0],k[1],label=k[2],linewidth = 1.5,linestyle = '-')
        
            
        plt.title("Instanteous Throughput of UDP Connection",fontdict=self.font1,fontweight='bold')
        plt.xlabel("Time",labelpad=10,fontdict=self.font2)
        plt.ylabel("Throughput (Mbps)",labelpad=25,fontdict=self.font2)
        plt.show()
        
    def mipScenario1(self,file):
    
        """ For PLotting the Instantaneous Throughput for mip Scenario1  """
        
        xp1  = []
        xp2  = []
        yp1  = []
        yp2  = []
        
        with open(file,'r') as fp:
            for i in fp:
                z = i.split()
                if(float(z[0]) >= 67.0 and float(z[0]) < 98.5):
                    xp1.append(float(z[0]))
                    yp1.append(float(z[1]))
                    
                elif(float(z[0]) >= 98.5):
                    xp2.append(float(z[0]))
                    yp2.append(float(z[1]))
                
                
        plotdata = []
        plotdata.append((xp1,yp1,'MH in Home Agent'))
        plotdata.append((xp2,yp2,'MH in Foreign Agent'))
        
        for k in plotdata:
            plt.plot(k[0],k[1],label=k[2],linewidth = 1.5,linestyle = '-')
        
        
        plt.xlabel("Time",labelpad=10,fontdict=self.font2)
        plt.ylabel("Throughput (Mbps)",labelpad=20,fontdict=self.font2)
        plt.show()

    
    def mipScenario2(self,file):
    
        """ For PLotting the Instantaneous Throughput for mip Scenario2  """
        
        xp1  = []
        xp2  = []
        xp3  = []
        yp1  = []
        yp2  = []
        yp3  = []
        
        with open(file,'r') as fp:
            for i in fp:
                z = i.split()
                if(float(z[0]) >= 158.8):
                    xp3.append(float(z[0]))
                    yp3.append(float(z[1]))
                    
                elif(float(z[0]) >= 143.0 ):
                    xp2.append(float(z[0]))
                    yp2.append(float(z[1]))
                
                elif(float(z[0]) >= 139.0):
                    xp1.append(float(z[0]))
                    yp1.append(float(z[1]))
                
        plotdata = []
        plotdata.append((xp1,yp1,'CN in Home Agent'))
        plotdata.append((xp2,yp2,'CN in Foreign Agent'))
        plotdata.append((xp3,yp3,'CN in CN\'s Home Agent'))
        
        for k in plotdata:
            plt.plot(k[0],k[1],label=k[2],linewidth = 1.5,linestyle = '-')
        
        
        plt.xlabel("Time",labelpad=10,fontdict=self.font2)
        plt.ylabel("Throughput (Mbps)",labelpad=20,fontdict=self.font2)
        plt.show()
    


dp1 = DataPlotter()

dp1.udp_tput('res0.tr') 

dp1.cwndPlot('tahoeCW.tr','Tahoe')
dp1.cwndPlot('renoCW.tr','Reno')
dp1.cwndPlot('vegasCW.tr','Vegas') 

dp1.tcp_tput('tahoeTput.tr','Tahoe') 
dp1.tcp_tput('renoTput.tr','Reno') 
dp1.tcp_tput('vegasTput.tr','Vegas') 
   
dp1.mipScenario1('scene1.tr')   

dp1.mipScenario2('scene2.tr')  	
