% Modificaci?n al c?digo original, para que pueda leer todas las ROIS y NIfTI.
% IMPORTANTE: colocar las nii en una misma carpeta:semillas y sujetos;
% INPUT: numero de semillas, numero de sujetos, ruta de semillas y ruta de sujetos 
% OUTPUT: dos archivos por sujeto con extension IMG y HDR.  
% MODIFICACION: Ahora ya no importa el tama?o de las IMR, por diferentes TR; lo recupera y de ese tama??o hace la semilla para el c??lculo punto a punto
% MODIFICACION2: lee el archivo .filelist, que se genera desde Melodic_gui, para no copiar de nuevo los arvhivos nifti
% 22 diciembre 2023
% Gustavo P. R.

tic

clc, clear 

%cd('/Users/gus/Documents/MATLAB/melodic_SCA10/analisis_melodic_v2/v3_temporal pole left_seed_voxelwise y randomise')

n_sujetos = 39;     %<---------------Definir: 20Ctrls + 19SCA10 = 39
n_semillas = 1;    %<---------------Definir 


semillas = dir('seed_Somatomotor_network_reoriented_resize2.nii*');

%sujetos = importdata('/Users/gus/Desktop/sca10_rsfmri/groupmelodic.gica/.filelist');
sujetos = importdata('./dir_muestra.txt');

for i = 1 : n_semillas % solo leera los archivos del numero de sujetos que se deseen!  
    
    disp(['Semilla #', num2str(i)]);
    
    %sujetos = dir('*denoised_data_std.nii.gz*');
        
    for k = 1 : n_sujetos % solo leera los archivos del numero de sujetos que se deseen!
        disp(['Sujeto #', num2str(k)]);
        
        %codigo de Gabriel
        %func = load_untouch_nii (sujetos(k).name); 
        func = load_untouch_nii (strrep(char(strcat(sujetos(k),'.nii.gz')),'reg_standard/','')); % leer imagen desde ruta (Gustavo)
        seed = load_untouch_nii (semillas(i).name);
        seed4d = repmat(seed.img,1,1,1,145); % duplicar la semilla y convertirla en 4D (Gustavo)
        
        %Recuperando el tama?o de las im?genes (Gustavo)
        [x y z tiempo]  = size(func.img); 

        funcional = double(func.img);
        semilla = double (seed4d(:,:,:,1:tiempo)); %el tama?o de la seed dependera de la IRM (Gustavo) 
        mascara_bin = funcional .* semilla;
        sumatoria = sum(sum(sum(semilla)));
        sumatoria1 = max(sumatoria);
        serie_promedio = sum(sum(sum(mascara_bin))) / sumatoria1; serie_promedio = squeeze (serie_promedio) ;

        [Xx Yy Zz Tt] = size (funcional);

        for X= 1:Xx; 
            for Y= 1:Yy;
                for Z =1:Zz;
                    mapa_funcional(X,Y,Z)= corr(squeeze(funcional(X,Y,Z,:)),serie_promedio); 
                    
                    Z_fisher(X,Y,Z) = atanh(mapa_funcional(X,Y,Z)); %transformacion de Fisher (Gustavo)
                end
            end
        end
        

        % imagen fisher (Gustavo)
        ind = find (isnan(Z_fisher));
        Z_fisher(ind) = 0 ;
        z_nii = make_ana(Z_fisher, [2 2 2], [], [], '');
        %save_untouch_nii(z_nii, ['z_', semillas(i).name,'_',sujetos(k).name]); %<-------------prefijo "imagen" + nombre_semilla!
        save_untouch_nii(z_nii, ['z_',int2str(k),'_', semillas(i).name]); %<-------------prefijo "z" + #sujeto + nombre_semilla!
        
        
       

    end
    
end

toc
