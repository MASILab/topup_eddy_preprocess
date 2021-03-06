%% Set environment
addpath('system_utils');
addpath(genpath('nifti_utils'));
addpath(genpath('dwmri_visualizer'));
addpath('topup_eddy_preprocess');

%% Run topup/eddy preprocessing pipeline

% Set job directory path
job_dir_path = 'test_topup_eddy_preprocess';

% Set FSL path
fsl_path = '~/fsl_5_0_10_eddy_5_0_11';

% BET params
bet_params = '-f 0.3 -R';

% Set dwmri_info - this will set base path to nifti/bvec/bval, phase 
% encoding direction, and readout times
dwmri_info(1).base_path = 'scans/1000_32_1';
dwmri_info(1).scan_descrip = 'scan';
dwmri_info(1).pe_dir = 'A';
dwmri_info(2).base_path = 'scans/1000_6_rev';
dwmri_info(2).scan_descrip = 'b0';
dwmri_info(2).pe_dir = 'P';
dwmri_info(3).base_path = 'scans/2000_60';
dwmri_info(3).scan_descrip = 'scan';
dwmri_info(3).pe_dir = 'A';
dwmri_info(4).base_path = 'scans/1000_32_2';
dwmri_info(4).scan_descrip = 'scan';
dwmri_info(4).pe_dir = 'A';

% ADC fix - apply it for Philips scanner
ADC_fix = true;

% zero_bval_thresh - will set small bvals to zero
zero_bval_thresh = 50;

% prenormalize - will prenormalize data prior to eddy
prenormalize = true;

% use all b0s for topup
use_all_b0s_topup = false;

% topup params
topup_params = ['--subsamp=1,1,1,1,1,1,1,1,1 ' ...
                '--miter=10,10,10,10,10,20,20,30,30 ' ...
                '--lambda=0.00033,0.000067,0.0000067,0.000001,0.00000033,0.000000033,0.0000000033,0.000000000033,0.00000000000067'];

% Sometimes name of eddy is 'eddy', 'eddy_openmp', or 'eddy_cuda'
eddy_name = 'eddy_openmp';

% use b0s in eddy
use_b0s_eddy = false;

% eddy params
eddy_params = '--repol';

% normalize - will normalize data and output a single B0
normalize = true;

% sort scans - will sort scans by b-value
sort_scans = true;

% Set number of threads (only works if eddy is openmp version)
setenv('OMP_NUM_THREADS','20');

% Perform preprocessing
[dwmri_path, bvec_path, bval_path, mask_path, movement_params_path, topup_eddy_pdf_path] = ...
    topup_eddy_preprocess(job_dir_path, ...
                          dwmri_info, ...
                          fsl_path, ...
                          ADC_fix, ...
                          zero_bval_thresh, ...
                          prenormalize, ...
                          use_all_b0s_topup, ...
                          topup_params, ...
                          eddy_name, ...
                          use_b0s_eddy, ...
                          eddy_params, ...
                          normalize, ...
                          sort_scans, ...
                          bet_params);