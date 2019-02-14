package egov.linkpay.ims.baseinfomgmt;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.Region;
import org.apache.poi.xssf.streaming.SXSSFRow;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import egov.linkpay.ims.common.common.CommonUtils.PrintDateFormat;

/**------------------------------------------------------------
 * Package Name   : net.ionpay.dashboard.tradingviews
 * File Name      : VacctInputNotiExcelGenerator.java
 * Description    : 
 * Author         : hgkim, 2016. 07. 1.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class SettleReqMgmtExcelGenerator extends AbstractExcelView {
    Logger log = Logger.getLogger(this.getClass());
    
    @SuppressWarnings({ "unchecked", "deprecation" })
    @Override
    protected void buildExcelDocument(Map<String, Object> objExcelMap, HSSFWorkbook workbook, HttpServletRequest req, HttpServletResponse res) throws Exception {
        String strExcelName = "";

        Map<String,Object>       objReqMap    = null;
        List<Map<String,Object>> objExcelData = null;
        
        HSSFCellStyle cellLeftStyle      = null;
        HSSFCellStyle cellCenterStyle    = null;
        HSSFCellStyle cellNumCenterStyle = null;
        HSSFCellStyle cellRightStyle     = null;
        HSSFCellStyle cellTitleStyle     = null;
        HSSFCellStyle cellSubTitleStyle  = null;
        
        HSSFFont      fontTitle          = null;
        HSSFFont      fontSubTitle       = null;
        HSSFSheet     sheet              = null;
        HSSFRow       menuRow            = null;
        HSSFCell      cell               = null;
        
        try {
            strExcelName = (String) objExcelMap.get("excelName");
            objExcelData = (List<Map<String,Object>>) objExcelMap.get("excelData"); //디비에서 가져온 값
            objReqMap    = (Map<String,Object>) objExcelMap.get("reqData"); //FORM에서 가져온 값
            
            res.setContentType("application/msexcel");
            res.setHeader("Content-Disposition", "attachment; filename=" + strExcelName + ".xls");
            
            cellLeftStyle      = workbook.createCellStyle();
            cellCenterStyle    = workbook.createCellStyle();
            cellNumCenterStyle = workbook.createCellStyle();
            cellRightStyle     = workbook.createCellStyle();
            cellTitleStyle     = workbook.createCellStyle();
            cellSubTitleStyle  = workbook.createCellStyle();
            fontTitle          = workbook.createFont();
            fontSubTitle       = workbook.createFont();
            
            cellRightStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
            cellNumCenterStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
            
            CommonUtils.CoverCellStyle(workbook, cellLeftStyle,      HSSFCellStyle.ALIGN_LEFT,   HSSFCellStyle.VERTICAL_CENTER);
            CommonUtils.CoverCellStyle(workbook, cellCenterStyle,    HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER);
            CommonUtils.CoverCellStyle(workbook, cellNumCenterStyle, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER);
            CommonUtils.CoverCellStyle(workbook, cellRightStyle,     HSSFCellStyle.ALIGN_RIGHT,  HSSFCellStyle.VERTICAL_CENTER);
            CommonUtils.CoverCellStyle(workbook, cellTitleStyle,     fontTitle, HSSFCellStyle.ALIGN_CENTER,  HSSFCellStyle.VERTICAL_CENTER, 24);
            CommonUtils.CoverCellStyle(workbook, cellSubTitleStyle,  fontSubTitle, HSSFCellStyle.ALIGN_CENTER,  HSSFCellStyle.VERTICAL_CENTER, 10);
            
            sheet = workbook.createSheet(strExcelName);            
            
            menuRow = sheet.createRow(0);
            cell = menuRow.createCell(0);
            if(objReqMap.get("EXCEL_TYPE").equals("EXCEL"))
            {

//            	cell.setCellValue(CommonMessageDic.getMessage("IMS_DASHBOARD_0029"));
            	
            	
            	cell.setCellValue("NO");
            	cell.setCellStyle(cellCenterStyle);
            	
            	cell = menuRow.createCell(1);
            	cell.setCellValue("TID");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue("MID");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue("GID");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue("VID");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue("지불수단");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue("구분");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue("승인일자");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue("취소일자");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue("구매자");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue("상품명");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellValue("결제금액");
            	cell.setCellStyle(cellCenterStyle);
            	
            }

            
            int currentRow = 1;

            if (objExcelData.isEmpty()){
                menuRow = sheet.createRow(currentRow);
                
                for(int i=0; i<=11; i++) { //test 10 cnt
                    cell = menuRow.createCell(i);
                    sheet.setColumnWidth(currentRow, sheet.getColumnWidth(currentRow) + 1000);
                    
                    if (i == 0) {
                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
                    }
                    
                    cell.setCellStyle(cellCenterStyle);
                }
                
                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,11));
            } else {
            	for(int i=0; i<=11; i++) { 
            		sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1000);
            	}
            	
                for(Map<String, Object> objMap : objExcelData) {                    
                    menuRow = sheet.createRow(currentRow);
                    //sheet.autoSizeColumn(currentRow);
                        
                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
                    {                            
                    	cell = menuRow.createCell(0);
                    	String rNumVal = String.valueOf(((Double) objMap.get( "RNUM" )).intValue());
                    	cell.setCellValue(rNumVal);
                    	cell.setCellStyle(cellCenterStyle);
                    	
                    	cell = menuRow.createCell(1);
                    	cell.setCellValue(objMap.get( "TID" )==null?"":objMap.get( "TID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(2);
                    	cell.setCellValue(objMap.get( "MID" )==null?"":objMap.get( "MID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(3);
                    	cell.setCellValue(objMap.get( "GID" )==null?"":objMap.get( "GID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(4);
                    	cell.setCellValue(objMap.get( "VID" )==null?"":objMap.get( "VID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(5);
                    	cell.setCellValue(objMap.get( "PM_CD_NM" )==null?"":objMap.get( "PM_CD_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	
                    	String trxStatCdVal = "";
                    	if(objMap.get( "TRX_STAT_CD" )!=null) {
                    		if(objMap.get( "TRX_STAT_CD" ).toString().equals("0")) {
                    			trxStatCdVal = "승인";
                    		}else if(objMap.get( "TRX_STAT_CD" ).toString().equals("2")) {
                    			trxStatCdVal = "취소";
                    		}
                    	}
                    	
                    	cell = menuRow.createCell(6);
                    	cell.setCellValue(trxStatCdVal);
                    	cell.setCellStyle(cellCenterStyle);
                    	
                    	cell = menuRow.createCell(7);
                    	cell.setCellValue(objMap.get( "APP_DT" )==null?"":CommonUtils.ConvertPrintDate(PrintDateFormat.YYYYMMDD, objMap.get( "APP_DT" ).toString()));
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(8);
                    	cell.setCellValue(objMap.get( "CC_DT" )==null?"":CommonUtils.ConvertPrintDate(PrintDateFormat.YYYYMMDD, objMap.get( "CC_DT" ).toString()));
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(9);
                    	cell.setCellValue(objMap.get( "ORD_NM" )==null?"":objMap.get( "ORD_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(10);
                    	cell.setCellValue(objMap.get( "GOODS_NM" )==null?"":objMap.get( "GOODS_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(11);
                    	cell.setCellValue(objMap.get( "GOODS_AMT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "GOODS_AMT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	
                    	
                    }
                    currentRow++;
                }
            }
        } catch(Exception ex) {   
        	log.debug( "Exception : " ,ex );
            strExcelName = "Error";
            sheet = workbook.createSheet(strExcelName);            
            GetOccurredException(sheet);
        } finally {
            res.setHeader("Set-Cookie", "fileDownload=true; path=/;");
        }
    }    
    
    /**--------------------------------------------------
     * Method Name    : GetOccurredException
     * Description    : Occurred Exception
     * Author         : yangjeongmo, 2015. 10. 6.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private void GetOccurredException(HSSFSheet sheet) {
        HSSFRow  menuRow = sheet.createRow(0);
        HSSFCell cell    = menuRow.createCell(0);
        cell.setCellValue("Occurred Error.");
    }
}