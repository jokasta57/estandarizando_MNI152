% Reorientando al espacio MNI152
% ejemplo de uso: estandarizando_MNI152('seed_cerebellar_right_crus_ii_all.nii.gz', 'seed_cerebellar_right_crus_ii_all_std.nii');
% Gustavo P.R. 12-abril-23

function estandarizando_MNI152(x, nombre_img)
    nii = load_nii(x);
    nii.hdr.hist.sform_code = 0;
    nii.hdr.hist.srow_x = [-2 1 0 90];
    nii.hdr.hist.srow_y = [1 2 0 -126];
    nii.hdr.hist.srow_z = [0 0 2 -72];
    nii.hdr.hist.originator = [46 64 37 0 -32768];
    nii.hdr.hist.rot_orient = [1 2 3];
    nii.hdr.hist.flip_orient = [3 0 0];
    nii.hdr.hist.qoffset_x = 90;
    nii.hdr.hist.qoffset_y = -126;
    nii.hdr.hist.qoffset_z = -72;
    nii.hdr.hist.quatern_c = 1;
    save_nii(nii, nombre_img);
end
