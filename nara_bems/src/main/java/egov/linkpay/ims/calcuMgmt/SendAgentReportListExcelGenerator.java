package egov.linkpay.ims.calcuMgmt;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
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
public class SendAgentReportListExcelGenerator extends AbstractExcelView {
    Logger log = Logger.getLogger(this.getClass());
    
    @SuppressWarnings({ "unchecked", "deprecation" })
    @Override
    protected void buildExcelDocument(Map<String, Object> objExcelMap, HSSFWorkbook workbook, HttpServletRequest req, HttpServletResponse res) throws Exception {
        String strExcelName = "";

        Map<String,Object>       objReqMap    = null;
        Map<String,Object>       objDMap    = null;
        Map<String,Object>       objTotMap    = null;
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
            objDMap    = (Map<String,Object>) objExcelMap.get("dMap"); 
            objTotMap    = (Map<String,Object>) objExcelMap.get("totMap"); 
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
            
            menuRow = sheet.createRow(2);
            cell = menuRow.createCell(1);
            if(objReqMap.get("EXCEL_TYPE").equals("EXCEL"))
            {
            	String stmtDt = objReqMap.get( "stmtDt" )==null?"":(String)objReqMap.get( "stmtDt" );
            	
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )1 , ( int) 1, (short )12 ));
            	sheet. addMergedRegion (new Region(( int) 2 , ( short )1 , ( int) 3, (short )12 ));
            	
            	sheet. addMergedRegion (new Region(( int) 30 , ( short )1 , ( int) 32, (short )1 ));
            	
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_MENU_SUB_0109"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(4);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0658"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_SM_SR_0034"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_SM_SR_0036"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0659"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(8);
            	cell = menuRow.createCell(1);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0565"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0142"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0083"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0646"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0160"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0647"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0556"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0648"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0649"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0633"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0555"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0573"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(30);
            	cell = menuRow.createCell(1);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0574"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0585"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(objDMap.get( "CONF1_TM" )==null?"":objDMap.get( "CONF1_TM" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(31);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0587"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(objDMap.get( "CONF2_TM" )==null?"":objDMap.get( "CONF2_TM" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(32);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0565"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(objDMap.get( "CONF3_TM" )==null?"":objDMap.get( "CONF3_TM" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(34);
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0660"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0661"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0662"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_SM_SR_0036"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0663"));
            	cell.setCellStyle(cellCenterStyle);
            	
            }

            
            int currentRow = 9;

            if (objExcelData.isEmpty()){
                menuRow = sheet.createRow(currentRow);
                
                for(int i=0; i<11; i++) { 
                    cell = menuRow.createCell(i);
                    
                    if (i == 0) {
                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
                    }
                    
                    cell.setCellStyle(cellCenterStyle);
                }
                
                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,10));
            } else {
                for(Map<String, Object> objMap : objExcelData) {                    
                    menuRow = sheet.createRow(currentRow);
                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
                    {                           
                    	log.info( "row : " +  (currentRow+objExcelData.size()));
                		sheet. addMergedRegion (new Region(( int) 9 , ( short )1 , ( int) (currentRow+objExcelData.size()), (short )1 ));
                		cell = menuRow.createCell(1);
                		cell.setCellValue(objMap.get( "STMT_DT" ).toString());
                		cell.setCellStyle(cellCenterStyle);
                    	
                    	cell = menuRow.createCell(2);
                    	cell.setCellValue(objMap.get( "VGRP_NM" )==null?"":objMap.get( "VGRP_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(3);
                    	cell.setCellValue(objMap.get( "CO_NO" )==null?"":objMap.get( "CO_NO" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(4);
                    	cell.setCellValue(objMap.get( "TRANS_YYMM" )==null?"":objMap.get( "TRANS_YYMM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(5);
                    	cell.setCellValue(objMap.get( "TRANAMT" )==null?"":objMap.get( "TRANAMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(6);
                    	cell.setCellValue(objMap.get( "FEE" )==null?"0":objMap.get( "FEE" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(7);
                    	cell.setCellValue(objMap.get( "VAT" )==null?"0":objMap.get( "VAT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(8);
                    	cell.setCellValue(objMap.get( "PAY_AMT" )==null?"0":objMap.get( "PAY_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(9);
                    	cell.setCellValue(objMap.get( "PAY_VAT" )==null?"0":objMap.get( "PAY_VAT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(10);
                    	cell.setCellValue(objMap.get( "RESR_AMT" )==null?"0":objMap.get( "RESR_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(11);
                    	cell.setCellValue(objMap.get( "EXTRA_AMT" )==null?"0":objMap.get( "EXTRA_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(12);
                    	cell.setCellValue(objMap.get( "DPST_AMT" )==null?"0":objMap.get( "DPST_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    }
                    currentRow++;
                }
                menuRow = sheet.createRow(currentRow);
            	sheet. addMergedRegion (new Region(( int) currentRow , ( short )2 , ( int) currentRow, (short )3 ));
                cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0176"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue(objTotMap.get( "size" )==null?"":objTotMap.get( "size" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue(objTotMap.get( "sumTranAmt" )==null?"":objTotMap.get( "sumTranAmt" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue(objTotMap.get( "sumFee" )==null?"":objTotMap.get( "sumFee" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(objTotMap.get( "sumVat" )==null?"":objTotMap.get( "sumVat" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(objTotMap.get( "sumPayAmt" )==null?"":objTotMap.get( "sumPayAmt" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(objTotMap.get( "sumPVat" )==null?"":objTotMap.get( "sumPVat" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(objTotMap.get( "sumResrAmt" )==null?"":objTotMap.get( "sumResrAmt" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellValue(objTotMap.get( "sumExtraAmt" )==null?"":objTotMap.get( "sumExtraAmt" ).toString());
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellValue(objTotMap.get( "sumDepositAmt" )==null?"":objTotMap.get( "sumDepositAmt" ).toString());
            	cell.setCellStyle(cellCenterStyle);
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