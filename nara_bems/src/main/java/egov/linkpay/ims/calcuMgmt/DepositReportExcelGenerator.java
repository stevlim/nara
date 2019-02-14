package egov.linkpay.ims.calcuMgmt;

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
public class DepositReportExcelGenerator extends AbstractExcelView {
    Logger log = Logger.getLogger(this.getClass());
    
    @SuppressWarnings({ "unchecked", "deprecation" })
    @Override
    protected void buildExcelDocument(Map<String, Object> objExcelMap, HSSFWorkbook workbook, HttpServletRequest req, HttpServletResponse res) throws Exception {
        String strExcelName = "";

        Map<String,Object>       objReqMap    = null;
        
        List<Map<String,Object>> objExcelTotalData = null;
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
        
        HSSFRow       menuTotalRow            = null;
        HSSFCell      totalCell               = null;
        
        HSSFRow       menuTotalDescRow            = null;
        HSSFCell      totalDescCell               = null;
        
        HSSFRow       menuTotalHeadRow            = null;
        HSSFCell      totalHeadCell               = null;
        
        HSSFRow       menuTotalValRow            = null;
        HSSFCell      totalValCell               = null;
        
        HSSFRow       menuRow            = null;
        HSSFCell      cell               = null;
        
        String fromDateVal = "";
        String toDateVal = "";
        
        try {
            strExcelName = (String) objExcelMap.get("excelName");
            
            objExcelTotalData = (List<Map<String,Object>>) objExcelMap.get("excelTotalData"); //디비에서 가져온 값
            objExcelData = (List<Map<String,Object>>) objExcelMap.get("excelData"); //디비에서 가져온 값
            objReqMap    = (Map<String,Object>) objExcelMap.get("reqData"); //FORM에서 가져온 값
            
            fromDateVal = objReqMap.get("fromdate").toString();
            toDateVal = objReqMap.get("todate").toString();
            
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

            menuTotalRow = sheet.createRow(0);
            totalCell = menuTotalRow.createCell(0);
            
            menuTotalDescRow = sheet.createRow(1);
            totalDescCell = menuTotalDescRow.createCell(0);
            
            menuTotalHeadRow = sheet.createRow(2);
            totalHeadCell = menuTotalHeadRow.createCell(0);
            
            menuTotalValRow = sheet.createRow(3);
            totalValCell = menuTotalValRow.createCell(0);
            
            menuRow = sheet.createRow(5);
            cell = menuRow.createCell(0);
            
            if(objReqMap.get("EXCEL_TYPE").equals("EXCEL"))
            {

            	totalCell.setCellValue("* 입금합계");
            	//totalCell.setCellStyle(cellCenterStyle);
            	
            	totalDescCell.setCellValue("아래 내역의 조회 기간은 " + fromDateVal + " ~ " + toDateVal + " 입니다.");
            	//totalDescCell.setCellStyle(cellCenterStyle);
            	
            	totalHeadCell.setCellValue("결제금액");
            	totalHeadCell.setCellStyle(cellCenterStyle);
            	totalHeadCell = menuTotalHeadRow.createCell(1);
            	totalHeadCell.setCellValue("취소금액");
            	totalHeadCell.setCellStyle(cellCenterStyle);
            	totalHeadCell = menuTotalHeadRow.createCell(2);
            	totalHeadCell.setCellValue("지급보류");
            	totalHeadCell.setCellStyle(cellCenterStyle);
            	totalHeadCell = menuTotalHeadRow.createCell(3);
            	totalHeadCell.setCellValue("보류해제");
            	totalHeadCell.setCellStyle(cellCenterStyle);
            	totalHeadCell = menuTotalHeadRow.createCell(4);
            	totalHeadCell.setCellValue("별도가감");
            	totalHeadCell.setCellStyle(cellCenterStyle);
            	totalHeadCell = menuTotalHeadRow.createCell(5);
            	totalHeadCell.setCellValue("수수료");
            	totalHeadCell.setCellStyle(cellCenterStyle);
            	totalHeadCell = menuTotalHeadRow.createCell(6);
            	totalHeadCell.setCellValue("VAT");
            	totalHeadCell.setCellStyle(cellCenterStyle);
            	totalHeadCell = menuTotalHeadRow.createCell(7);
            	totalHeadCell.setCellValue("입금액");
            	totalHeadCell.setCellStyle(cellCenterStyle);
            	
            	
            	totalValCell.setCellValue(CommonUtils.amtCommaFormat(objExcelTotalData.get(0).get("APP_AMT").toString())+"원");
            	totalValCell.setCellStyle(cellRightStyle);
            	totalValCell = menuTotalValRow.createCell(1);
            	totalValCell.setCellValue(CommonUtils.amtCommaFormat(objExcelTotalData.get(0).get("CAN_AMT").toString())+"원");
            	totalValCell.setCellStyle(cellRightStyle);
            	totalValCell = menuTotalValRow.createCell(2);
            	totalValCell.setCellValue(CommonUtils.amtCommaFormat(objExcelTotalData.get(0).get("RESR_AMT").toString())+"원");
            	totalValCell.setCellStyle(cellRightStyle);
            	totalValCell = menuTotalValRow.createCell(3);
            	totalValCell.setCellValue(CommonUtils.amtCommaFormat(objExcelTotalData.get(0).get("RESR_CC_AMT").toString())+"원");
            	totalValCell.setCellStyle(cellRightStyle);
            	totalValCell = menuTotalValRow.createCell(4);
            	totalValCell.setCellValue(CommonUtils.amtCommaFormat(objExcelTotalData.get(0).get("EXTRA_AMT").toString())+"원");
            	totalValCell.setCellStyle(cellRightStyle);
            	totalValCell = menuTotalValRow.createCell(5);
            	totalValCell.setCellValue(CommonUtils.amtCommaFormat(objExcelTotalData.get(0).get("FEE").toString())+"원");
            	totalValCell.setCellStyle(cellRightStyle);
            	totalValCell = menuTotalValRow.createCell(6);
            	totalValCell.setCellValue(CommonUtils.amtCommaFormat(objExcelTotalData.get(0).get("VAT").toString())+"원");
            	totalValCell.setCellStyle(cellRightStyle);
            	totalValCell = menuTotalValRow.createCell(7);
            	totalValCell.setCellValue(CommonUtils.amtCommaFormat(objExcelTotalData.get(0).get("DEPOSIT_AMT").toString())+"원");
            	totalValCell.setCellStyle(cellRightStyle);
            	
            	
            	
            	cell.setCellValue("NO");
            	cell.setCellStyle(cellCenterStyle);
            	
            	cell = menuRow.createCell(1);
            	cell.setCellValue("MID");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue("입금일");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue("결제금액");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue("취소금액");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue("지급보류");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue("보류해제");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue("별도가감");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue("수수료");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue("VAT");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue("입금액");
            	cell.setCellStyle(cellCenterStyle);
            	/*cell = menuRow.createCell(11);
            	cell.setCellValue("고객 ID");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellValue("거래상태");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(13);*/
            	/*cell.setCellValue("에스크로 ");
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(14);
            	cell.setCellValue("상태");
            	cell.setCellStyle(cellCenterStyle);*/
            }

            
            int currentRow = 6;

            if (objExcelData.isEmpty()){
                menuRow = sheet.createRow(currentRow);
                
                for(int i=0; i<=10; i++) { //test 10 cnt
                    cell = menuRow.createCell(i);
                    sheet.setColumnWidth(currentRow, sheet.getColumnWidth(currentRow) + 1000);
                    
                    if (i == 0) {
                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
                    }
                    
                    cell.setCellStyle(cellCenterStyle);
                }
                
                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,10));
            } else {
            	for(int i=0; i<=10; i++) { 
            		sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1000);
            	}
            	
                for(Map<String, Object> objMap : objExcelData) {                    
                    menuRow = sheet.createRow(currentRow);
                    //sheet.autoSizeColumn(currentRow);
                        
                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
                    {                            
                    	cell = menuRow.createCell(0);
                    	//String rNumVal = String.valueOf(((Double) objMap.get( "RNUM" )).intValue());
                    	String rNumVal = objMap.get( "RNUM" ).toString().replaceAll("\\.0", "");
                    	cell.setCellValue(rNumVal);
                    	//cell.setCellValue(objMap.get( "RNUM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	
                    	cell = menuRow.createCell(1);
                    	cell.setCellValue(objMap.get( "MID" )==null?"":objMap.get( "MID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(2);
                    	cell.setCellValue(objMap.get( "STMT_DT" )==null?"":CommonUtils.ConvertPrintDate(PrintDateFormat.YYYYMMDD, objMap.get( "STMT_DT" ).toString()));
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(3);
                    	cell.setCellValue(objMap.get( "APP_AMT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "APP_AMT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	cell = menuRow.createCell(4);
                    	cell.setCellValue(objMap.get( "CAN_AMT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "CAN_AMT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	cell = menuRow.createCell(5);
                    	cell.setCellValue(objMap.get( "RESR_AMT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "RESR_AMT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	
                    	cell = menuRow.createCell(6);
                    	cell.setCellValue(objMap.get( "RESR_CC_AMT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "RESR_CC_AMT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	cell = menuRow.createCell(7);
                    	cell.setCellValue(objMap.get( "EXTRA_AMT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "EXTRA_AMT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	cell = menuRow.createCell(8);
                    	cell.setCellValue(objMap.get( "FEE" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "FEE" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	cell = menuRow.createCell(9);
                    	cell.setCellValue(objMap.get( "VAT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "VAT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	cell = menuRow.createCell(10);
                    	cell.setCellValue(objMap.get( "DEPOSIT_AMT" )==null?"":CommonUtils.amtCommaFormat(objMap.get( "DEPOSIT_AMT" ).toString())+"원");
                    	cell.setCellStyle(cellRightStyle);
                    	
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