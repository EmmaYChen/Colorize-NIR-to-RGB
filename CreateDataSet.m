% inImg;  % Cell array of sensor raw data
% outImg; % Cell array of target output
function [inImg, outImg] = CreateDataSet(data_size)
    
    inImg = cell(1, data_size);
    outImg = cell(1, data_size);
    
    current_dir = pwd;
    ir_dir = [current_dir,'/IRSensorData/'];
    ir_S = dir(fullfile(ir_dir,'*.mat')); 
   
    rgb_dir = [current_dir,'/RGBImageData/'];
    rgb_S = dir(fullfile(rgb_dir,'*.mat')); 
    
    % Todo: check database size boundary/*numel(ir_S)*/, now data_size is between 0~27

    for k = 1:data_size
       
%         disp(ir_S(k).name);
%         disp(rgb_S(k).name);
        
        % ToDo: make sure ir and rgb match
        
        temp_ir_file = fullfile(ir_dir,ir_S(k).name);
        temp_in = load(temp_ir_file);
%         disp(size(temp_in.ir_sensor_data));
        inImg{k} = temp_in.ir_sensor_data;
        
        temp_rgb_file = fullfile(rgb_dir,rgb_S(k).name);
        temp_out = load(temp_rgb_file);
%         disp(size(temp_out.rgb_image_data));
        outImg{k} = temp_out.rgb_image_data;
      
    end
      
end