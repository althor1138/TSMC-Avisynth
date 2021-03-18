function TSMC(clip input, int "tradius", int "mthresh", int "lumathresh", int "blocksize",clip "auxclip")
{
t=Defined(tradius)
tradius=t ? tradius : 3
# temporal radius-number of frames analyzed before/after current frame.

m=Defined(mthresh)
mthresh=m ? mthresh : 70
# motion threshold-higher numbers denoise areas with higher motion.
#Anything above this number does not get denoised.

l=Defined(lumathresh)
lumathresh=l ? lumathresh : 255
# luma threshold- Denoise pixels that match in surrounding frames.
#255 is the maximum and default. 0-255 are valid numbers.
#Also adjusts chroma threshold.

b=Defined(blocksize)
blocksize=b ? blocksize : 8
#larger numbers = faster processing times

aux=Defined(auxclip)
auxclip=aux ? auxclip : input#.tweak(cont=1.2).blur(1.58).blur(1.58).blur(1.58)
#w=width(input)
#h=height(input)
    
    
    prefilt=auxclip
    super=MSuper(input, pel=2)
    superfilt=MSuper(prefilt,pel=2)
   
    multivectors=Manalyse(superfilt,multi=true,delta=tradius,temporal=true,blksize=blocksize,overlap=blocksize/2)
    multivectors2=Mrecalculate(superfilt,multivectors,thsad=mthresh,tr=tradius,blksize=blocksize,overlap=blocksize/2)
    mc=Mcompensate(input,super,multivectors2,thsad=mthresh,tr=tradius,center=true)
    dnmc=mc.temporalsoften(tradius,lumathresh,lumathresh,15,2)
    decimate=selectevery(dnmc,tradius * 2 + 1,tradius)
    return(decimate)
}
