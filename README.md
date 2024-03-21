Código en Matlab, para estandarizar imágenes NifTI 4D, después de aplicar un análisis de Voxelwise.

Pd.- Se adjunta archivo para llevar a cabo un análisis por Voxel-wise en imágenes rsfMRI, y ROIs esféricas. Despues de ejecutar el Script de «redes_funcionales.m», el cual hace el voxelwise de cada "semillas 4D" vs "*denoised_data_std.nii.gz*", es necesario convertir en los archivos *.HDR a imágenes NifTI (nii):

for i in $(ls *.hdr); do fslchfiletype NIFTI $i ; done


Pd.- se anexa la biblioteca «nifti_utils-master», la cual se debe agregar desde «Set path» de Matlab, para poder trabajar con imágenes NIfTI.
