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
public class AgentStmtConfirmListExcelGenerator extends AbstractExcelView {
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
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )0 , ( int) 1, (short )0 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )1 , ( int) 1, (short )1 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )2 , ( int) 1, (short )2 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )3 , ( int) 1, (short )3 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )4 , ( int) 1, (short )4 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )5 , ( int) 0, (short )8 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )9 , ( int) 1, (short )9 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )10 , ( int) 1, (short )10 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )11 , ( int) 1, (short )11 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )12 , ( int) 1, (short )12 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )13 , ( int) 1, (short )13 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )14 , ( int) 1, (short )14 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )15 , ( int) 1, (short )15 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )16 , ( int) 1, (short )16 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )17 , ( int) 1, (short )17 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )18 , ( int) 1, (short )18 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )19 , ( int) 1, (short )19 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )20 , ( int) 1, (short )20 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )21 , ( int) 1, (short )21 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )22 , ( int) 1, (short )22 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )23 , ( int) 1, (short )23 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )24 , ( int) 1, (short )24 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )25 , ( int) 1, (short )25 ));
            	
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_DASHBOARD_0029"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(1);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0631"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0632"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(CommonMessageDic.getMessage("DDLB_0139"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0571"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0364"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_SM_SR_0018"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0623"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0437"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0556"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(13);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0624"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(14);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0625"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(15);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0640"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(16);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0641"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(17);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0642"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(18);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0634"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(19);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0635"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(20);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0557"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(21);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0643"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(22);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0644"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(23);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0574"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(24);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0626"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(25);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0645"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(1);
            	
            	cell = menuRow.createCell(1);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0280"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0281"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0282"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0283"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(13);
            	cell = menuRow.createCell(14);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(15);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(16);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(17);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(18);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(19);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(20);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(21);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(22);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(23);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(24);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(25);
            	cell.setCellStyle(cellCenterStyle);
            }

            
            int currentRow = 2;

            if (objExcelData.isEmpty()){
                menuRow = sheet.createRow(currentRow);
                
                for(int i=0; i<=25; i++) { 
                    cell = menuRow.createCell(i);
                    
                    if (i == 0) {
                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
                    }
                    
                    cell.setCellStyle(cellCenterStyle);
                }
                
                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,25));
            } else {
                for(Map<String, Object> objMap : objExcelData) {                    
                    menuRow = sheet.createRow(currentRow);
                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
                    {                            
                    	cell = menuRow.createCell(0);
                    	cell.setCellValue(objMap.get( "RNUM" )==null?"":objMap.get( "RNUM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(1);
                    	cell.setCellValue(objMap.get( "TRAN_DT" )==null?"":objMap.get( "TRAN_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(2);
                    	cell.setCellValue(objMap.get( "VGRP_NM" )==null?"":objMap.get( "VGRP_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(3);
                    	cell.setCellValue(objMap.get( "VID" )==null?"":objMap.get( "VID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(4);
                    	cell.setCellValue(objMap.get( "REP_NM" )==null?"":objMap.get( "REP_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(5);
                    	cell.setCellValue(objMap.get( "CARD_AMT" )==null?"":objMap.get("CARD_AMT").toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(6);
                    	cell.setCellValue(objMap.get( "APP_AMT" )==null?"":objMap.get( "APP_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(7);
                    	cell.setCellValue(objMap.get( "VAPP_AMT" )==null?"":objMap.get( "VAPP_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(8);
                    	cell.setCellValue(objMap.get( "PHONE_AMT" )==null?"":objMap.get( "PHONE_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(9);
                    	cell.setCellValue(objMap.get( "ORG_FEE" )==null?"":objMap.get( "ORG_FEE" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(10);
                    	cell.setCellValue(objMap.get( "SALES_ORG_FEE" )==null?"":objMap.get( "SALES_ORG_FEE" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(11);
                    	cell.setCellValue(objMap.get( "FEE" )==null?"":objMap.get( "FEE" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(12);
                    	cell.setCellValue(objMap.get( "VAT" )==null?"":objMap.get( "VAT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(13);
                    	cell.setCellValue(objMap.get( "PAY_AMT" )==null?"":objMap.get( "PAY_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(14);
                    	cell.setCellValue(objMap.get( "PAY_VAT" )==null?"":objMap.get( "PAY_VAT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(15);
                    	cell.setCellValue(objMap.get( "RESR_AMT" )==null?"":objMap.get( "RESR_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(16);
                    	cell.setCellValue(objMap.get( "RESR_CC_AMT" )==null?"":objMap.get( "RESR_CC_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(17);
                    	cell.setCellValue(objMap.get( "EXTRA_AMT" )==null?"":objMap.get( "EXTRA_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(18);
                    	cell.setCellValue(objMap.get( "CARD_FLAT_CNT" )==null?"":objMap.get( "CARD_FLAT_CNT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(19);
                    	cell.setCellValue(objMap.get( "CARD_FLAT_FEE" )==null?"":objMap.get( "CARD_FLAT_FEE" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(20);
                    	cell.setCellValue(objMap.get( "DPST_AMT" )==null?"":objMap.get( "DPST_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(21);
                    	cell.setCellValue(objMap.get( "CARRY_DPST_AMT" )==null?"":objMap.get( "CARRY_DPST_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(22);
                    	cell.setCellValue(objMap.get( "TOT_AMT" )==null?"":objMap.get( "TOT_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	if(!objMap.get( "CONFIRM_FLG" ).equals( "0" )){
                    		cell = menuRow.createCell(23);
                    		cell.setCellValue(objMap.get( "CONFIRM_DT" )==null?"":objMap.get( "CONFIRM_DT" ).toString());
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(24);
                    		cell.setCellValue("");
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(25);
                    		cell.setCellStyle(cellCenterStyle);
                    	}else{
                    		if(!objMap.get( "CARRY_CL" ).equals( "0" )){
	                    		cell = menuRow.createCell(23);
	                    		cell.setCellStyle(cellCenterStyle);
	                    		cell.setCellValue("");
	                    		cell = menuRow.createCell(24);
	                    		cell.setCellValue(objMap.get( "CARRY_DT" )==null?"":objMap.get( "CARRY_DT" ).toString());
	                    		cell.setCellStyle(cellCenterStyle);
	                    		cell = menuRow.createCell(25);
	                    		cell.setCellStyle(cellCenterStyle);
                    		}else{
                    			cell = menuRow.createCell(23);
                        		cell.setCellValue("");
	                    		cell.setCellStyle(cellCenterStyle);
	                    		cell = menuRow.createCell(24);
	                    		cell.setCellStyle(cellCenterStyle);
	                    		cell = menuRow.createCell(25);
	                    		cell.setCellStyle(cellCenterStyle);
                    		}
                    	}
                    	if(!objMap.get( "ST_TYPE" ).equals( "0" )){
                    		cell = menuRow.createCell(25);
                    		cell.setCellValue(objMap.get( "TAX_DT" )==null?"":objMap.get( "TAX_DT" ).toString());
                    		cell.setCellStyle(cellCenterStyle);
                    	}
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