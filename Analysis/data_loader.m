function [ ] = data_loader(  )
%DATA_LOADER Summary of this function goes here
%   Detailed explanation goes here
root_fp = '/Users/newberry/Desktop/Pilo Analysis/';
fp = root_fp;

    function[filenames] = get_filenames( root_fp )
        filenames_unformated_1 = ls(root_fp);
        filenames_unformated_2 = strrep(filenames_unformated_1,'?','');
        filenames = strsplit(filenames_unformated_2,'	');
%         last_fn = filenames( length(filenames) );
%         last_fn_length = length(last_fn);
%         filenames( length(filenames) ) = last_fn(1:last_fn_length-1);
%         formatted_fns = { , last_fn(1:last_fn_length-1) }
    end

foldernames_1 = get_filenames( root_fp );
foldernames_2 = get_filenames( strcat(root_fp,foldernames_1{1},'/') );
foldernames_3 = get_filenames( strcat(root_fp,foldernames_1{1},'/',...
    foldernames_2{1},'/') )
fp = strcat(root_fp,foldernames_1{1},'/',foldernames_2{1},'/',...
    foldernames_3{1},'/');
filenames = get_filenames( fp );
fp
class(filenames)
length(filenames{1})


end

