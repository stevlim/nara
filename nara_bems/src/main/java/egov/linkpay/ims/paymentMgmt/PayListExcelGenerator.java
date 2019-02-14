package egov.linkpay.ims.paymentMgmt;

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
public class PayListExcelGenerator extends AbstractExcelView {
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
            	cell.setCellValue("가맹점명");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue("결제일자");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue("결제시간");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue("취소일자");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue("취소시간");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue("MID");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue("상품명");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue("결제금액");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue("구매자");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellValue("고객 ID");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellValue("거래상태");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(13);
            	/*cell.setCellValue("에스크로 ");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(14);
            	cell.setCellValue("상태");
            	cell.setCellStyle(cellCenterStyle);*/
            }

            
            int currentRow = 1;

            if (objExcelData.isEmpty()){
                menuRow = sheet.createRow(currentRow);
                
                for(int i=0; i<=12; i++) { //test 10 cnt
                    cell = menuRow.createCell(i);
                    sheet.setColumnWidth(currentRow, sheet.getColumnWidth(currentRow) + 1000);
                    
                    if (i == 0) {
                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
                    }
                    
                    cell.setCellStyle(cellCenterStyle);
                }
                
                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,12));
            } else {
            	for(int i=0; i<=12; i++) { 
            		sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1000);
            	}
            	
                for(Map<String, Object> objMap : objExcelData) {                    
                    menuRow = sheet.createRow(currentRow);
                    //sheet.autoSizeColumn(currentRow);
                    
                    
                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
                    {                            
                    	cell = menuRow.createCell(0);
                    	String rNumVal = objMap.get("RNUM").toString().replaceAll("\\.0", ""); //String.valueOf().intValue());
                    	cell.setCellValue(rNumVal);
                    	//cell.setCellValue(objMap.get( "RNUM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	
                    	cell = menuRow.createCell(1);
                    	cell.setCellValue(objMap.get( "TID" )==null?"":objMap.get( "TID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(2);
                    	cell.setCellValue(objMap.get( "CO_NM" )==null?"":objMap.get( "CO_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(3);
                    	cell.setCellValue(objMap.get( "APP_DT" )==null?"":objMap.get( "APP_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(4);
                    	cell.setCellValue(objMap.get( "APP_DT_HIS" )==null?"":objMap.get( "APP_DT_HIS" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(5);
                    	cell.setCellValue(objMap.get( "CC_DT" )==null?"":objMap.get( "CC_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	
                    	cell = menuRow.createCell(6);
                    	cell.setCellValue(objMap.get( "CC_DT_HIS" )==null?"":objMap.get( "CC_DT_HIS" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(7);
                    	cell.setCellValue(objMap.get( "MID" )==null?"":objMap.get( "MID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(8);
                    	cell.setCellValue(objMap.get( "GOODS_NM" )==null?"":objMap.get( "GOODS_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(9);
                    	cell.setCellValue(objMap.get( "GOODS_AMT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "GOODS_AMT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	cell = menuRow.createCell(10);
                    	cell.setCellValue(objMap.get( "ORD_NM_ENC" )==null?"":objMap.get( "ORD_NM_ENC" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(11);
                    	cell.setCellValue(objMap.get( "UID" )==null?"":objMap.get( "UID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(12);
                    	
                    	String trxNmVal = "";
                    	if(objMap.get( "TRX_ST_CD" )!=null) {
                    		if(objMap.get( "TRX_ST_CD" ).toString().equals("0")) {
                    			trxNmVal = "승인";
                    		}else if(objMap.get( "TRX_ST_CD" ).toString().equals("1")) {
                    			trxNmVal = "전취소";
                    		}else if(objMap.get( "TRX_ST_CD" ).toString().equals("2")) {
                    			trxNmVal = "후취소";
                    		}
                    	}
                    	
                    	cell.setCellValue(trxNmVal);
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(13);
                    	/*cell.setCellValue(objMap.get( "TRX_ST_NM" )==null?"":objMap.get( "TRX_ST_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(14);
                    	cell.setCellValue(objMap.get( "GOODS_AMT" )==null?"":objMap.get( "GOODS_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);*/
                    	
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