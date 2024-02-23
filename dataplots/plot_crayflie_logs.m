function plot_crayflie_logs(datetag)
% function that plots data from log files generated from CrazyS position controller

  initPlots;
  ifig = 0;
  printFigs = 1;
  
##  datetag = '20240223T143929';
  logs_folder = '../datalogs/';
  fname_pos = [logs_folder datetag '_DronePosition.csv'];
  fname_att = [logs_folder datetag '_DroneAttitude.csv'];
  fname_oms = [logs_folder datetag '_PropellersVelocity.csv'];
  
  filename = [logs_folder datetag '_results'];

  % data is given in first columns, and last two columns are, respectively, the time in seconds and the nanoseconds
  data_pos = csvread(fname_pos)';
  data_att = csvread(fname_att)';
  data_oms = csvread(fname_oms)';
  nk = size(data_pos,2);
  
  t = data_pos(end-1,:) + data_pos(end,:)*1e-9; # get time in seconds
  p = data_pos(1:3,:);
  lbd = data_att(1:3,:);
  oms = data_oms(1:4,:);
  
  % 3D plot
  ifig = ifig+1;
  figure(ifig);
  plot3(p(1,:),p(2,:),p(3,:));
  hold on;
  plot3(p(1,1),p(2,1),p(3,1),'og','MarkerSize',2);
  plot3(p(1,end),p(2,end),p(3,end),'xr','MarkerSize',2);
  hold off;
  grid on;
  axis equal;
  xlabel('$$p_1$$ [m]');
  ylabel('$$p_2$$ [m]');
  zlabel('$$p_3$$ [m]');
  title('Vehicle trajectory');
  legend('traj','ini','end');
  print2pdf([filename '_traj'],printFigs);
  title('3-D trajectory');
  
  % actuation (rotor angular velocities
  ifig = ifig+1;
  figure(ifig);
  nu = 4;
  for iu = 1:nu
    subplot(nu,1,iu);
    plot(t,oms(iu,:));
    grid on;
    ylabel(['$$\omega_' num2str(iu) '(t) [rad/s]$$']);
  end
  xlabel('$$t$$ [s]');
  print2pdf([filename '_oms'],printFigs);
  title('Rotor angular velocities');
  
  ifig = ifig+1;
  figure(ifig);
  for ivar = 1:3
      subplot(3,1,ivar);
      plot(t,p(ivar,:));
      grid on;
      ylabel(['$$p_' num2str(ivar) '(t) [m]$$']);
  end
  xlabel('$$t$$ [s]');
  print2pdf([filename '_pos'],printFigs);
  title('Vehicle position');
  
  ifig = ifig+1;
  figure(ifig);
  subplot(311);
  for ivar = 1:3
      subplot(3,1,ivar);
      plot(t,lbd(ivar,:)*180/pi);
      grid on;
      ylabel(['$$\lambda_' num2str(ivar) '(t) [deg]$$']);
  end
  xlabel('$$t$$ [s]');
  print2pdf([filename '_eul'],printFigs);
  title('Attitude (euler angles)');


end