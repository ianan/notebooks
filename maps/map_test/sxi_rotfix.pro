pro sxi_rotfix

  ; With SSWIDL load in a SXI fits file, rotate and submap and then save out
  ; Doing it this way as sunpy has issues with sxi files and, in general, rotate+submap
  ;
  ; 09-Aug-2017 IGH
  ;
  ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  ; Load in our SXI file
  dir=''
  infile='SXI_20150901_033615143_BA_15.FTS'
  data=readfits(dir+infile,hdr)

  ; make a map
  index2map,hdr,data,mapin

  ; correct the rotation
  map=rot_map(mapin,-1.*mapin.roll_angle)
  ; rough correction of the offset
  map=shift_map(map,50,0)
  ; Square the map about S/C
  sub_map,map,smap0,xrange=[-1200,1200],yrange=[-1200,1200]

  ; check it looks ok
  loadct,1,/silent
  gamma_ct,0.5
  plot_map,smap0,/log,dmin=2,grid_spacing=15,/limb,xrange=[-1200,1200],yrange=[-1200,1200]

  ; save the map out
  map2fits,smap0,dir+'oSXI_'+break_time(map.time)+'.fits'
  ; need to use tweaked version for sunpy - otherwise will not work in sunpy!
  map2fits_sunpy,smap0,dir+'SXI_'+break_time(map.time)+'.fits'
  
  ; Is this also an issue with other fits files???
  ; try with an AIA one i.e. http://jsoc.stanford.edu/data/aia/synoptic/2015/09/01/H0300/AIA20150901_0336_0304.fits
  ; Less on an issue as can load AIA straight into sunpy, but might want to do something in sswidl first
  
  
  infa='AIA20150901_0336_0304.fits'
  read_sdo,infa,aind,adata
  index2map,aind,adata,mapa
  loadct,3,/silent
  plot_map,mapa,/log
   map2fits,mapa,dir+'oSXI_'+break_time(map.time)+'.fits'
  
  

  stop
end