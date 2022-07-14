%Load up case 
clear all;
clc;
define_constants
mpc = loadcase('case24_ieee_rts');
[num, temp] = size(mpc.bus);
[gen, temp] = size(mpc.gen);
[bra, temp] = size(mpc.branch);
mpopt = mpoption;

% mpc.bus(mpc.gen(:,1),3:4)
% mpc.gen(:,2:3) 
% mpc.bus(mpc.gen(:,1),3:4) = mpc.gen(:,2:3) - mpc.bus(mpc.gen(:,1),3:4); 

display(mpc.bus(mpc.gen(:,1),3:4) )
pf = runpf(mpc);

i = 1;
temp = size(mpc.bus);
temp_gen = zeros(temp(1),2);

while i <= length(mpc.bus)
    temp_gen(i,:) = sum(mpc.gen(find(mpc.gen(:,1)==i),2:3),1);
    i = i+1;
end

%Run case for 5,9,14, 24, 39, 57, 118

%% Get sum of load 
% sum_PL = sum(mpc.bus(:,3));
% sum_PQ = sum(mpc.bus(:,4));

%% Generate Data

sample = 40000;
data_set_x = zeros(num*5,sample);
data_set_y = zeros(num*2,sample);
data_set_pf = zeros(bra*2,sample);
data_set_dc = zeros(bra,sample);


a = 1;


while a <= sample
      mpc = loadcase('case24_ieee_rts');
      mpopt.pf.nr.max_it = 25;  
      ori_PL = sum(mpc.bus(:,3));
      ori_QL = sum(mpc.bus(:,4));
%     mpc.bus(:,8) = rand(num,1)*0.2+0.9;         %Random initial voltage between 0.9 and 1.1 p.u
%     temp = rand(num,1)*2-1;
%     mpc.bus(:,3) = temp/sum(temp)*sum_PL;       %Random load active power demand between 0 to 100 MW
%     temp = rand(num,1)*2-1;
%     mpc.bus(:,4) = temp/sum(temp)*sum_PQ;       %Random load reactive power demand between -100 to 100 MW  
%     
%     temp = rand(gen,1);
%     mpc.gen(:,2) = temp/sum(temp)*sum_PL*1.1;   %Random generator active power between 0 to 100 MW
%     mpc.gen(:,9) = temp/sum(temp)*sum_PL*1.5;   %Random max generator active power between 100 to 200 MW
%     temp = rand(gen,1)*2-1;
%     mpc.gen(:,3) = temp/sum(temp)*sum_PQ*1.1;   %Random generator reactive power between -100 to 100 MW

%     mpc.bus(:,8) = rand(num,1)*0.12+0.94;         %Random initial voltage between 0.94 and 1.06 p.u
% 
%     mpc.bus(:,3) = rand(num,1)*100;           %Random load active power demand between 0 to 100 MW
% 
%     mpc.bus(:,4) = rand(num,1)*200-100;       %Random load reactive power demand between -100 to 100 MW  
%     
% 
%     mpc.gen(:,2) = rand(gen,1)*100;         %Random generator active power between 0 to 100 MW
%     mpc.gen(:,9) = rand(gen,1)*100+300;   %Random max generator active power between 100 to 200 MW
% 
%     mpc.gen(:,3) = rand(gen,1)*200-100;   %Random generator reactive power between -100 to 100 MW
    
    mpc.bus(:,8) = rand(num,1)*0.12+0.94;         %Random initial voltage between 0.94 and 1.06 p.u

    mpc.bus(:,3) = mpc.bus(:,3).*(rand(num,1)*0.15+0.8); %Random load active power between 87.5% and 112.5% of original

    mpc.bus(:,4) = mpc.bus(:,4).*(rand(num,1)*0.15+0.8); %Random load reactive power between 87.5% and 112.5% of original
    
    mpc.gen(:,2) = (sum(mpc.bus(:,3))/ori_PL) * mpc.gen(:,2);
    
    mpc.gen(:,3) = (sum(mpc.bus(:,4))/ori_QL) * mpc.gen(:,3);
    
  

%     mpc.gen(:,2) = sum(mpc.bus(:,3)).*(rand(gen,1)*0.2+0.8);      %Random generator active power between 80% and 120% of original
%     mpc.gen(:,9) = mpc.gen(:,9).*(rand(gen,1)*0.2+0.8);   %Random max generator active power between 80% and 120% of original
% 
%     mpc.gen(:,3) = mpc.gen(:,3).*(rand(gen,1)*0.2+0.8);   %Random generator reactive power between 80% and 120% of original


    pf = runpf(mpc);                            %Solve power flow
    dcpf = rundcpf(mpc);
    clc
    if pf.success == 1    
        
        i = 1;
        temp = size(mpc.bus);
        temp_gen = zeros(temp(1),2);

        while i <= temp(1)
            temp_gen(i,:) = sum(mpc.gen(find(mpc.gen(:,1)==i),2:3),1);
            i = i+1;
        end
%         mpc.bus(:,3:4) = (temp_gen) - mpc.bus(:,3:4);
        bus_gen = [ temp_gen mpc.bus(:,[3 4 8]) ];
    %     mpc.bus(mpc.gen(:,1),3:4) = mpc.gen(:,2:3) - mpc.bus(mpc.gen(:,1),3:4);     %Total power inject at each bus
    %     temp = zeros(size(mpc.bus(:,3:4)));
    %     temp(mpc.gen(:,1),:) = mpc.gen(:,2:3);
    %     new_temp = [temp mpc.bus(:,[3 4 8]) ];

%         data_set_x(:,a) = reshape(mpc.bus(:,[3 4 8]),[num*3,1]);
        data_set_x(:,a) = reshape(bus_gen,[num*5,1]);
        data_set_y(:,a) = reshape(pf.bus(:,[8 9]),[num*2,1]);
        data_set_pf(:,a) = reshape(pf.branch(:,[14 15]),[bra*2,1]);
        data_set_dc(:,a) = reshape(dcpf.branch(:,14),[bra,1]);

        a = a+1;

    end

end

%  data_set_x(1:num*2,:)     =  data_set_x(1:num*2,:)/100;            %Convert from MW to pu (100MW base)
%  data_set_y(num+1:num*2,:) =  data_set_y(num+1:num*2,:)*pi/180;     %Convert from degrees to radians for angle


%% Write data to csv file

writematrix(data_set_x,['data_x_pf_' num2str(num) '.csv' ]);
writematrix(data_set_y,['data_y_' num2str(num) '.csv' ]);
writematrix(data_set_pf,['data_y_pf_' num2str(num) '.csv' ]);
writematrix(data_set_dc,['data_y_dc_' num2str(num) '.csv' ]);

