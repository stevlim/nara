package egov.linkpay.ims.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDataFormatter;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;


public class StringUtils {
	
	public static List<String> getArrayObject(Object o){
		List<String> result = new ArrayList<String>();
		
		try {
			if(o instanceof String){
				result.add((String)o);
			}else if(o instanceof List ){
				result = (List<String>) o;
			}else{
				result = null;
			}
		} catch (Exception e) {
			e.printStackTrace();
			result = null;
		}
		
		return result;
	}
	
	public static String delBracket (String str, String replaceStr) {
		str = str.replaceAll("\\[", "");  // text 형식에 앞에 붙음.
		str = str.replaceAll("\\]", "");  // text 형식에 뒤에 붙음.
		if( str.equals("null"))
			str = replaceStr;
		return str;
	 }	
	
	/**
	 * 스트링이 일정 길이 이상이면 자르고 ...을 붙인다.
	 * 한글인 경우 2byte 처리.
	 * @param str   resource Str
	 * @param size  제한길이
	 * @return cutStr   변환 스트링 ( 일정길이 이상인 경우에만 ... 보이도록 )
	 *  HTML 에서도 처리 가능..
			<div style="width:120; text-overflow:ellipsis; overflow:hidden;">111111111111111111111111111111111111</div>
	 */
	public static String cutString(String str, int size){
		
		String tail = "...";
		if(str == null)            return null;

		int srcLen = str.getBytes().length;
		if(srcLen < size)            return str;

		String tmpTail = tail;
		if(tail == null)            tmpTail = "";

		int tailLen = tmpTail.getBytes().length;
		if(tailLen > size)            return "";

		int i = 0;
		int realLen = 0;
		for (i = 0; realLen < size; i++) {
			char a = str.charAt(i);
			if((a & 0xff00) == 0)		realLen++;
			else				        realLen += 2;
		}
		return str.substring(0, i) + tail;
	}
	
	
	/**
	 * 엑셀파일 -> List<Map<String,Object>> 로 변환
	 * 
	 * @param
	 * @return
	 * @throws IOException 
	 */
	public static List<Map<String,Object>> excelToListMap(String filePath, int sheetNum, int startRowNum) throws IOException {
		
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		
		final int CELL_ROWS = 69;
		HSSFDataFormatter numberFormatter = new HSSFDataFormatter();
		
		String ext = filePath.substring( filePath.lastIndexOf( "." ) + 1 );
		
		FileInputStream fis = new FileInputStream(filePath);		
				
		if(ext.toLowerCase().equals("xlsx")){
			
			XSSFWorkbook workbook=new XSSFWorkbook(fis);
			
			int rowindex=0;
			int columnindex=0;
			
			XSSFSheet sheet=workbook.getSheetAt(sheetNum);
			
			int rows=sheet.getPhysicalNumberOfRows();
			
			for(rowindex = startRowNum-1 ; rowindex < rows ; rowindex++){
				
			    XSSFRow row=sheet.getRow(rowindex);
			    
			    if(row !=null){
			    	
			    	Map<String,Object> rowModel = new HashMap<String,Object>();
										
			        int cells=CELL_ROWS;
			        
			        rowModel.put("cells", cells);
			        
			        for(columnindex=0 ; columnindex <= cells ; columnindex++){
			        	
			            XSSFCell cell=row.getCell(columnindex);
			            String value="";
			            
			            if(cell!=null){
			            	cell.setCellType(Cell.CELL_TYPE_STRING);
			            	
			                switch (cell.getCellType()){
			                case XSSFCell.CELL_TYPE_FORMULA:
			                    value=cell.getCellFormula();
			                    break;
			                case XSSFCell.CELL_TYPE_NUMERIC:
			                    value= String.valueOf((float)cell.getNumericCellValue());
			                    break;
			                case XSSFCell.CELL_TYPE_STRING:
			                    value=cell.getStringCellValue()+"";
			                    break;
			                case XSSFCell.CELL_TYPE_BLANK:
			                    value=cell.getBooleanCellValue()+"";
			                    break;
			                case XSSFCell.CELL_TYPE_ERROR:
			                    value=cell.getErrorCellValue()+"";
			                    break;
			                }
			            }
			            
			            rowModel.put(String.valueOf(columnindex), value);
			            
			        }
			        
			        list.add(rowModel);
			        
			    }
			}
			
		}else{
			
			HSSFWorkbook workbook = new HSSFWorkbook(fis);
			
			int rowindex = 0;
			int columnindex = 0;

			HSSFSheet sheet = workbook.getSheetAt(sheetNum);
			int rows = sheet.getPhysicalNumberOfRows();

			for (rowindex = 1; rowindex < rows; rowindex++) {
				
				HSSFRow row = sheet.getRow(rowindex);
				
				if (row != null) {
					
					Map<String,Object> rowModel = new HashMap<String,Object>();
					
					int cells = row.getPhysicalNumberOfCells();
					
					rowModel.put("cells", cells);
							
					for (columnindex = 0; columnindex <= cells; columnindex++) {
						
						HSSFCell cell = row.getCell(columnindex);
						String value = "";
						
						if (cell != null) {
							cell.setCellType(Cell.CELL_TYPE_STRING);
							
							switch (cell.getCellType()) {
							case HSSFCell.CELL_TYPE_FORMULA:
								value = cell.getCellFormula();
								break;
							case HSSFCell.CELL_TYPE_NUMERIC:
								value = cell.getNumericCellValue() + "";
								break;
							case HSSFCell.CELL_TYPE_STRING:
								value = cell.getStringCellValue() + "";
								break;
							case HSSFCell.CELL_TYPE_BLANK:
								value = cell.getBooleanCellValue() + "";
								break;
							case HSSFCell.CELL_TYPE_ERROR:
								value = cell.getErrorCellValue() + "";
								break;
							}
						}
						rowModel.put(String.valueOf(columnindex), value);
					}
					
					list.add(rowModel);
					
				}
			}
			
		}
		
		return list;
		
	}
	
}
