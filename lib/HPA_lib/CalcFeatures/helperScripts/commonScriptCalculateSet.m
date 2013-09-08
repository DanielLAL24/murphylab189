switch fsetnames{zed}
  case 'tas'
    [names, feats, slfnames] = ml_tas( protstruct.channel,0);

  case 'tasx2'
    downsampleProteinChannel
    
    [names, feats, slfnames] = ml_tas( protstruct.downsampled2x,0);
    
    renameDownsampled

  case 'mutualInfo'
    loadNucleusChannel; loadMicrotubuleChannel; loadERChannel; 
    
    sprot = size(protstruct.channel);
    prot_re = reshape(protstruct.channel,[sprot(1)*sprot(2) 1]);
    nuc_re = reshape(nucstruct.channel,[sprot(1)*sprot(2) 1]);
    tub_re = reshape(tubstruct.channel,[sprot(1)*sprot(2) 1]);
    er_re = reshape(erstruct.channel,[sprot(1)*sprot(2) 1]);

    commonScriptMutualInformation
    
  case 'mutualInfox2'
    loadNucleusChannel; loadMicrotubuleChannel; loadERChannel; 

    downsampleAllChannels

    sprot = size(protstruct.downsampled2x);
    prot_re = reshape(protstruct.downsampled2x,[sprot(1)*sprot(2) 1]);
    nuc_re = reshape(nucstruct.downsampled2x,[sprot(1)*sprot(2) 1]);
    tub_re = reshape(tubstruct.downsampled2x,[sprot(1)*sprot(2) 1]);
    er_re = reshape(erstruct.downsampled2x,[sprot(1)*sprot(2) 1]);

    commonScriptMutualInformation

    renameDownsampled

  case 'texture'
    prot = protstruct.channel;
    commonScriptTexture

  case 'texturex2'
    downsampleProteinChannel

    prot = protstruct.downsampled2x;
    commonScriptTexture

    renameDownsampled

  case 'texturex4'
    DSF = 4;
    downsampleProteinChannel

    prot = protstruct.downsampled4x;
    commonScriptTexture

    renameDownsampled
    DSF = 2;

  case 'overlap'
    loadNucleusChannel; loadMicrotubuleChannel; loadERChannel;

    thresholdAllChannels

    tmp_prot = protstruct.channel;
    tmp_prot_fg = protstruct.channel_fg;
    tmp_nuc_fg = nucstruct.channel_fg;
    tmp_tub_fg = tubstruct.channel_fg;
    tmp_er_fg = erstruct.channel_fg;
    tmp_prot_mfg = protstruct.channel_mfg;
    tmp_prot_large_fg = protstruct.channel_large_fg;
    tmp_prot_large_mfg = protstruct.channel_large_mfg;

    commonScriptOverlap

  case 'overlapx2'
    loadNucleusChannel; loadMicrotubuleChannel; loadERChannel;

    downsampleAllChannels

    thresholdDownsampled2xAllChannels

    tmp_prot = protstruct.downsampled2x;
    tmp_prot_fg = protstruct.downsampled2x_fg;
    tmp_nuc_fg = nucstruct.downsampled2x_fg;
    tmp_tub_fg = tubstruct.downsampled2x_fg;
    tmp_er_fg = erstruct.downsampled2x_fg;
    tmp_prot_mfg = protstruct.downsampled2x_mfg;
    tmp_prot_large_fg = protstruct.downsampled2x_large_fg;
    tmp_prot_large_mfg = protstruct.downsampled2x_large_mfg;

    commonScriptOverlap

    renameDownsampled

  case 'nonObjFluor'
    loadNucleusChannel; loadMicrotubuleChannel; loadERChannel;

    thresholdAllChannels

    prot_int = sum(protstruct.channel_fg(:));
    bg_prot = protstruct.channel;
    bg_prot(protstruct.channel>protstruct.channel_thr) = 0;
    prot_int_large = sum(protstruct.channel_large_fg(:));

    prot_int_mthr = sum(protstruct.channel_mfg(:));
    bg_prot_mthr = protstruct.channel;
    bg_prot_mthr(protstruct.channel>protstruct.channel_mthr) = 0;
    prot_int_large_mthr = sum(protstruct.channel_large_mfg(:));

    commonScriptNOF

  case 'nonObjFluorx2'
    loadNucleusChannel; loadMicrotubuleChannel; loadERChannel;

    downsampleAllChannels

    thresholdDownsampled2xAllChannels

    prot_int = sum(protstruct.downsampled2x_fg(:));
    bg_prot = protstruct.downsampled2x;
    bg_prot(protstruct.downsampled2x>protstruct.downsampled2x_thr) = 0;
    prot_int_large = sum(protstruct.downsampled2x_large_fg(:));

    prot_int_mthr = sum(protstruct.downsampled2x_mfg(:));
    bg_prot_mthr = protstruct.downsampled2x;
    bg_prot_mthr(protstruct.downsampled2x>protstruct.downsampled2x_mthr) = 0;
    prot_int_large_mthr = sum(protstruct.downsampled2x_large_mfg(:));

    commonScriptNOF

    renameDownsampled

  case 'obj'
    loadNucleusChannel

    thresholdProteinChannel;  thresholdNucleusChannel;

    protobjs = protstruct.channel_objectsizes;
    largeprotobjs = protstruct.channel_large_objectsizes;

    protobjs_mthr = protstruct.channel_mobjectsizes;
    largeprotobjs_mthr = protstruct.channel_large_mobjectsizes;

    nucobjs = nucstruct.channel_objectsizes;

    normEuN = bweuler(protstruct.channel_fg>0,8)/length(nucobjs);
    normEuN_mthr = bweuler(protstruct.channel_mfg>0,8)/length(nucobjs);

    commonScriptObject;

  case 'objx2'
    loadNucleusChannel

    downsampleProteinChannel;  downsampleNucleusChannel;

    thresholdDownsampled2xProteinChannel;  thresholdDownsampled2xNucleusChannel;

    protobjs = protstruct.downsampled2x_objectsizes;
    largeprotobjs = protstruct.downsampled2x_large_objectsizes;

    protobjs_mthr = protstruct.downsampled2x_mobjectsizes;
    largeprotobjs_mthr = protstruct.downsampled2x_large_mobjectsizes;

    nucobjs = nucstruct.downsampled2x_objectsizes;

    normEuN = bweuler(protstruct.downsampled2x_fg>0,8)/length(nucobjs);
    normEuN_mthr = bweuler(protstruct.downsampled2x_mfg>0,8)/length(nucobjs);

    commonScriptObject;

    renameDownsampled

  case 'objRegion'
    loadNucleusChannel

    thresholdProteinChannel;  thresholdNucleusChannel;

    [names, feats, slfnames] = ml_imgfeatures( protstruct.channel_fg, nucstruct.channel_fg);

    if length(feats)~=14
        feats = repmat(nan, [1 14]);
    end

  case 'objRegionx2'
    loadNucleusChannel

    downsampleProteinChannel;  downsampleNucleusChannel;

    thresholdDownsampled2xProteinChannel;  thresholdDownsampled2xNucleusChannel;

    [names, feats, slfnames] = ml_imgfeatures( protstruct.downsampled2x_fg, nucstruct.downsampled2x_fg);

    if length(feats)~=14
        feats = repmat(nan, [1 14]);
    end

    renameDownsampled



  otherwise
    error('improper feature set specified');
end
