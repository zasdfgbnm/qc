C*************************************************************
      subroutine Get2EInt(naobasfn)
C     
C     Get two electron integrals
C         
C*************************************************************
      implicit double precision (a-h,o-z)
c
      logical FileExist
      integer and,or,nut,naobasfn,ifile
      character*4 filename(4)
c
      common /machsp/ iintln,ifltln,iintfp,ialone,ibitwd
c
      dimension 
c     &          G1(naobasfn*naobasfn*naobasfn*naobasfn/8),
     &          G2(naobasfn,naobasfn,naobasfn,naobasfn), 
     &          buf(600),ibuf(600)
c
      iupki(int)=and(int,ialone)
      iupkj(int)=and(ishft(int,-ibitwd),ialone)
      iupkk(int)=and(ishft(int,-2*ibitwd),ialone)
      iupkl(int)=and(ishft(int,-3*ibitwd),ialone)
      ipack(i,j,k,l)=or(or(or(i,ishft(j,ibitwd)),ishft(k,2*ibitwd)),
     &                  ishft(l,3*ibitwd))
      indx(i,j)=j+(i*(i-1))/2
      indx3(i,j)=i+(j*(j-1))/2
      indx2(i,j,n)=i+(j-1)*n
c
      filename(1)='IIII'
      filename(2)='IJIJ'
      filename(3)='IIJJ'
      filename(4)='IJKL'
c      filename='IIII','IJIJ','IIJJ','IJKL'
c      write(*,*) filename
c
      do 10 ifile=1,4
         FileExist=.false.
         inquire(file=filename(ifile),exist=FileExist)
         if (FileExist) then
c     write(*,*) filename(ifile),' exists'
c     
            open(unit=ifile,file=filename(ifile),form='UNFORMATTED',
     &           access='SEQUENTIAL')
            rewind ifile
c     
            call locate(ifile,'TWOELSUP')
            nut = 1
            do while (nut.ge.1)
               read(ifile) buf, ibuf, nut
               do int = 1, nut
                  ix=iupki(ibuf(int))
                  jx=iupkj(ibuf(int))
                  kx=iupkk(ibuf(int))
                  lx=iupkl(ibuf(int))
                  i=max(ix,jx)
                  j=min(ix,jx)
                  k=max(kx,lx)
                  l=min(kx,lx)
                  ind1=indx(i,j)
                  ind2=indx(k,l)
                  if(ind1.lt.ind2) then
                     ix=i
                     jx=j
                     i=k
                     j=l
                     k=ix
                     l=jx
                  endif
c     
                  x = buf(int)
c     
                  G2(i,j,k,l)=x
                  G2(i,j,l,k)=x
                  G2(j,i,k,l)=x
                  G2(j,i,l,k)=x
                  G2(k,l,j,i)=x
                  G2(k,l,i,j)=x
                  G2(l,k,i,j)=x
                  G2(l,k,j,i)=x
c     
                  ind3=indx(ind1,ind2)
c     
c      write(*,*) i,j,k,l,x
               end do
            end do
            close(ifile)
c     write(*,*) 'nut',nut
c     
c     write(*,*) IBITWD
c     
c     write(*,*) 'twoelec buf'
c     write(*,*) buf
c     write(*,*) 'twoelec ibuf'
c     write(*,*) ibuf
c     write(*,*) 'G2'
c     
c     
         else
         end if   
 10   continue  
c     
c output
      write (*,*) "2-electron integrals in 1122 notation"
      do i=1,naobasfn
         do j=1,naobasfn
            do k=1,naobasfn
               do l=1,naobasfn
                  write (*,*) G2(i,j,k,l)
               end do
            end do
         end do
      end do
      return
      end
