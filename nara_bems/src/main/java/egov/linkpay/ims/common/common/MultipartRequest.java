package egov.linkpay.ims.common.common;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.ServletInputStream;
import javax.servlet.ServletRequest;

public class MultipartRequest {

   private static final int DEFAULT_MAX_POST_SIZE = 1024*1024;  //1메가

   private ServletRequest req;
   private File dir;
   private int maxSize;

   private Hashtable<String,String> parameters = new Hashtable<String,String>();
   private Hashtable<String,UploadedFile> files = new Hashtable<String,UploadedFile>();

   public MultipartRequest(ServletRequest request, String saveDirectory) throws IOException
   {
      this(request, saveDirectory, DEFAULT_MAX_POST_SIZE);
   }

   public MultipartRequest(ServletRequest request, String saveDirectory, int maxPostSize) throws IOException
   {

      if(request == null){
         throw new IllegalArgumentException("request cannot be null");
      }

      if(saveDirectory == null){
         throw new IllegalArgumentException("saveDirectory cannot be null");
      }

      if(maxPostSize <= 0){
         throw new IllegalArgumentException("maxPostSize must be possible");
      }

      req = request;

      dir = new File(saveDirectory);
      maxSize = maxPostSize;

      if(!dir.isDirectory())
         throw new IllegalArgumentException("Not a Directory :");

      if(!dir.canWrite())
         throw new IllegalArgumentException("Not Writable: ");

      readRequest();
   }
   
   public MultipartRequest(ServletRequest request, String saveDirectory, int maxPostSize, String formName) throws IOException
   {

      if(request == null){
         throw new IllegalArgumentException("request cannot be null");
      }

      if(saveDirectory == null){
         throw new IllegalArgumentException("saveDirectory cannot be null");
      }

      if(maxPostSize <= 0){
         throw new IllegalArgumentException("maxPostSize must be possible");
      }
      
      if(formName == null){
          throw new IllegalArgumentException("formName must be possible");
       }
      
      req = request;

      dir = new File(saveDirectory);
      maxSize = maxPostSize;

      if(!dir.isDirectory())
         throw new IllegalArgumentException("Not a Directory :");

      if(!dir.canWrite())
         throw new IllegalArgumentException("Not Writable: ");

      readRequest(formName);
   }
   public Enumeration getParameterNames(){
      return parameters.keys();
   }

   public Enumeration getFileNames(){
      return files.keys();
   }

   public String getParameter(String name){
      try{
        String param = (String)parameters.get(name);

        if(param.equals("")) return null;

        return param;
      }catch(Exception e){
        return null;
      }
   }

   public String getFilesystemName(String name){
      try{
        UploadedFile file =(UploadedFile)files.get(name);
        return file.getFilesystemName();

      }catch(Exception e){
        return null;
      }
   }

   public String getContentType(String name){
      try{
        UploadedFile file = (UploadedFile) files.get(name);
        return file.getContentType();
      }catch(Exception e){
        return null;
      }
   }

   public File getFile(String name){
      try{
        UploadedFile file = (UploadedFile)files.get(name);
        return file.getFile();
      }catch(Exception e){
        return null;
      }
   }

   protected void readRequest() throws IOException{
      String type = req.getContentType();

      if(type == null || !type.toLowerCase().startsWith("multipart/form-data")){
        throw new IOException ("Posted content type isn't multipart/form-data");
      }

      int length = req.getContentLength();

      if( length > maxSize){
        throw new IOException("허용 파일 용량을 초과했습니다.");
      }

      String boundary = extractBoundary(type);

      if(boundary == null){
       throw new IOException("Separation boundary was not specified");
      }

      MultipartInputStreamHandler in = new MultipartInputStreamHandler(req.getInputStream(),boundary,length);

      String line = in.readLine();

      if(line == null){
         throw new IOException("Corrupt");
      }

      if(!line.startsWith(boundary)){
         throw new IOException("Corrupt from data");
      }

      boolean done = false ;
      while(!done){
         done = readNextPart(in, boundary);
      }
  }
   
   protected void readRequest(String formName) throws IOException{
	      String type = req.getContentType();

	      if(type == null || !type.toLowerCase().startsWith("multipart/form-data")){
	        throw new IOException ("Posted content type isn't multipart/form-data");
	      }

	      int length = req.getContentLength();

	      if( length > maxSize){
	        throw new IOException("허용 파일 용량을 초과했습니다.");
	      }

	      String boundary = extractBoundary(type);

	      if(boundary == null){
	       throw new IOException("Separation boundary was not specified");
	      }

	      MultipartInputStreamHandler in = new MultipartInputStreamHandler(req.getInputStream(),boundary,length);

	      String line = in.readLine();
	      if(line == null){
	         throw new IOException("Corrupt");
	      }

	      if(!line.startsWith(boundary)){
	         throw new IOException("Corrupt from data");
	      }

	      boolean done = false ;
	      while(!done){
	    	done = readNextPart(in, boundary, formName);
	      }
	  }
   
  protected boolean readNextPart(MultipartInputStreamHandler in, String boundary) throws IOException{

      String line = in.readLine();
      if( line == null){
          return true;
      }

      String[] dispInfo =extractDispositionInfo(line);
      String dispostion = dispInfo[0];

      String name = dispInfo[1];
      String filename = dispInfo[2];
      
      line = in.readLine();

      if(line == null){
        return true;
      }

      String contentType = extractContentType(line);
      if(contentType != null){
        line = in.readLine();

        if(line == null || line.length() > 0){
             throw new IOException(line);
        }
      }else{
         contentType ="application/octet-stream";
      }

      if(filename == null){
         String value = readParameter(in, boundary);  // Parameter를 읽음
         //LKB : multiselect인 경우 --> ~로 연결
           //검사
           String nametest;
           String valuetest;
           Enumeration paramtest = parameters.keys();

           while(paramtest.hasMoreElements()){
            nametest = (String)paramtest.nextElement();
            if((name.compareTo(nametest)) == 0 ){
                valuetest = getParameter(name);
                value = valuetest+"~"+value;
            }
       }
       //LKB
           parameters.put(name, value);
      }else{
         readAndSaveFile(in,boundary,filename);
         if(filename.equals("unknown")){
             files.put(name, new UploadedFile(null,null,null));
          }else{
                 files.put(name, new UploadedFile(dir.toString(),filename,contentType));
          }
      }
      return false;
  }
  
  protected boolean readNextPart(MultipartInputStreamHandler in, String boundary, String formName) throws IOException{
	   String line = in.readLine();
	      if( line == null){
	          return true;
	      }

	      String[] dispInfo =extractDispositionInfo(line);
	      String dispostion = dispInfo[0];

	      String name = dispInfo[1];
	      String filename = dispInfo[2];
	      
	      if(!formName.equals(name) && filename != null)   	  filename = "unknown";
	     
	      line = in.readLine();

	      if(line == null){
	        return true;
	      }

	      String contentType = extractContentType(line);
	      if(contentType != null){
	        line = in.readLine();

	        if(line == null || line.length() > 0){
	             throw new IOException(line);
	        }
	      }else{
	         contentType ="application/octet-stream";
	      }

	      if(filename == null){
	         String value = readParameter(in, boundary);  // Parameter를 읽음
	         //LKB : multiselect인 경우 --> ~로 연결
	           //검사
	           String nametest;
	           String valuetest;
	           Enumeration paramtest = parameters.keys();

	           while(paramtest.hasMoreElements()){
	            nametest = (String)paramtest.nextElement();
	            if((name.compareTo(nametest)) == 0 ){
	                valuetest = getParameter(name);
	                value = valuetest+"~"+value;
	            }
	       }
	       //LKB
	           parameters.put(name, value);
	      }else{
	    	  readAndSaveFile(in,boundary,filename);
	    	  if(filename.equals("unknown")){
	              files.put(name, new UploadedFile(null,null,null));
	           }else{
	              files.put(name, new UploadedFile(dir.toString(),filename,contentType));
	           }
	      }
	      return false;
  }

  protected String readParameter(MultipartInputStreamHandler in, String boundary) throws IOException{
      StringBuffer sbuf = new StringBuffer();
      String line;

      while((line = in.readLine()) != null){

        if(line.startsWith(boundary)) break;
        sbuf.append(line+"\r\n");
      }

      if(sbuf.length() == 0){
        return null;
      }

      sbuf.setLength(sbuf.length() -2);
      return sbuf.toString();
  }

  protected void readAndSaveFile(MultipartInputStreamHandler in, String boundary, String filename) throws IOException{

      File f = new File(dir+File.separator +filename);
      FileOutputStream fos = new FileOutputStream(f);

      BufferedOutputStream out = new BufferedOutputStream(fos, 8*1024);

      byte[] bbuf = new byte[8*1024];
      int result;
      String line;

      boolean rnflag = false;
      while((result = in.readLine(bbuf,0,bbuf.length)) != -1){

       if(result > 2 && bbuf[0] == '-' && bbuf[1] == '-'){
         line = new String(bbuf,0,result,"ISO-8859-1");
         if(line.startsWith(boundary)) break;

       }

       if(rnflag){
          out.write('\r');
          out.write('\n');
        rnflag = false;
       }

       if(result >= 2 && bbuf[result-2]=='\r' && bbuf[result-1] =='\n'){
          out.write(bbuf, 0, result- 2);
          rnflag = true;
       }else{
          out.write(bbuf,0,result);
       }
     }
     out.flush();
     out.close();
     fos.close();
     
     if(filename.equals("unknown")){
    	 f.delete();
     }
  }

  private String extractBoundary(String line){
     int index = line.indexOf("boundary=");

     if( index == -1){
         return null;
     }

     String boundary = line.substring(index + 9);

     boundary = "--" + boundary;

     return boundary;
  }

  private String[] extractDispositionInfo(String line) throws IOException{
     String[] retval = new String[3];

     String origline = line;
     line = origline.toLowerCase();


     int start = line.indexOf("content-disposition:");
     int end =line.indexOf(";");

     if(start == -1 || end == -1) {
        throw new IOException("Content dispostion corrupt :" + origline);
     }

     String dispostion = line.substring(start+21, end);

     if(!dispostion.equals("form-data")){
        throw new IOException("Invalid content dispostion: "+dispostion);
     }

     start = line.indexOf("name=\"",end);
     end = line.indexOf("\"",start+7);

     if(start==-1 || end == -1){
       throw new IOException("Content dispostion corrupt:"+origline);
     }

     String name = origline.substring(start+6,end);

     String filename = null;

     start = line.indexOf("filename=\"",end+2);
     end = line.indexOf("\"",start+10);

     if(start != -1&& end != -1){
        filename = origline.substring(start+10, end);
        int slash = Math.max(filename.lastIndexOf('/'),filename.lastIndexOf('\\'));

        if(slash > -1){
           filename = filename.substring(slash+1);
        }

        if(filename.equals("")) filename = "unknown";

     }

     retval[0] = dispostion;
     retval[1] = name;
     retval[2] = filename;
     return retval;
 }

 private String extractContentType(String line) throws IOException{
    String contentType = null;

    String origline = line;
    line = origline.toLowerCase();

    if( line.startsWith("content-type")){
       int start = line.indexOf(" ");
       if(start == -1 ){
          throw new IOException("Content type corrupt : "+origline);
       }

       contentType = line.substring(start + 1);
    }else if( line.length() != 0){
        throw new IOException("Malformed line after dispostion: " +origline);
    }

    return contentType;
 }
}

class UploadedFile{

    private String dir;
    private String filename;
    private String type;

    UploadedFile(String dir, String filename, String type){
       this.dir = dir;
       this.filename = filename;
       this.type = type;
    }

    public String getContentType(){
       return type;
    }

    public String getFilesystemName(){
       return filename;
    }

    public File getFile(){
       if(dir== null || filename == null){
          return null;
       }else {
          return new File(dir+File.separator+filename);
       }
    }

}


class MultipartInputStreamHandler{
   ServletInputStream in;
   String boundary;
   int totalExpected;
   int totalRead = 0;
   byte[] buf = new byte[8*1024];

   public MultipartInputStreamHandler(ServletInputStream in, String boundary, int totalExpected){
       this.in = in;
       this.boundary = boundary;
       this.totalExpected = totalExpected;

   }

   public String readLine() throws IOException{

      StringBuffer sbuf = new StringBuffer();
      int result;
      String line;

      do{
        result = this.readLine(buf,0,buf.length);

        if(result != -1) {
           sbuf.append(new String(buf,0,result,"UTF-8"));
           //sbuf.append(new String(buf,0,result,"KSC5601"));
        }
      }while(result == buf.length);

      if( sbuf.length() == 0) {
         return null;
      }

      sbuf.setLength(sbuf.length() -2);
      return sbuf.toString();
   }

   public int readLine(byte b[], int off, int len) throws IOException{
      if(totalRead >= totalExpected){
        return -1;
      }else{
        int result = in.readLine(b, off, len);
        if(result >0){
           totalRead += result;
        }
        return result;
      }
   }
}
