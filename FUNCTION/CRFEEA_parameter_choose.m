function [parameter01, parameter02, parameter03, parameter04] = CRFEEA_parameter_choose(datasetname)
switch datasetname
    case 'ORL_index4'
        parameter01 = 0.1;
        parameter02 = 0.01;
        parameter03 = 1;
        parameter04 = 1;
    case 'ORL_index5'
        parameter01 = 0.1;
        parameter02 = 0.01;
        parameter03 = 1;
        parameter04 = 1;
    case 'ORL_index6'
        parameter01 = 0.1;
        parameter02 = 0.01;
        parameter03 = 1;
        parameter04 = 1;
        
    case 'banc_index4'
        parameter01 = 0.1;
        parameter02 = 1;
        parameter03 = 1;
        parameter04 = 1;
    case 'banc_index5'
        parameter01 = 0.1;
        parameter02 = 1;
        parameter03 = 1;
        parameter04 = 1;
    case 'banc_index6'
        parameter01 = 0.1;
        parameter02 = 1;
        parameter03 = 1;
        parameter04 = 1;
        
    case 'coil_index5'
        parameter01 = 1;
        parameter02 = 0.1;
        parameter03 = 0.1;
        parameter04 = 1;
    case 'coil_index10'
        parameter01 = 1;
        parameter02 = 0.1;
        parameter03 = 0.1;
        parameter04 = 1;
    case 'coil_index15'
        parameter01 = 1;
        parameter02 = 0.1;
        parameter03 = 0.1;
        parameter04 = 1;
        
    case 'umist_index4'
        parameter01 = 0.1;
        parameter02 = 1;
        parameter03 = 5;
        parameter04 = 1;
    case 'umist_index5'
        parameter01 = 0.1;
        parameter02 = 1;
        parameter03 = 5;
        parameter04 = 1;
    case 'umist_index6'
        parameter01 = 0.1;
        parameter02 = 1;
        parameter03 = 5;
        parameter04 = 1;
end
end

