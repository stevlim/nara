package egov.linkpay.ims.businessmgmt;

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
public class CoApprInfoMListExcelGenerator extends AbstractExcelView {
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
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )5 , ( int) 1, (short )5 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )6 , ( int) 0, (short )13 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )14 , ( int) 0, (short )15 ));

            	cell.setCellValue(CommonMessageDic.getMessage("IMS_DASHBOARD_0029"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(1);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BM_CM_0032") +"/"+ CommonMessageDic.getMessage("IMS_BIM_BM_0475") );
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0142"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0476"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0477"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0478"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0479"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(14);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0480"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	
            	menuRow = sheet.createRow(1);
            	
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0194"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0483"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0396"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BM_CM_0079"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0280"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0281"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0282"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(13);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0283"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	cell = menuRow.createCell(14);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0195"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(15);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0434"));
            	cell.setCellStyle(cellCenterStyle);
            	
            }

            
            int currentRow = 2;

            if (objExcelData.isEmpty()){
                menuRow = sheet.createRow(currentRow);
                
                for(int i=0; i<=15; i++) { //test 10 cnt
                    cell = menuRow.createCell(i);
                    
                    if (i == 0) {
                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
                    }
                    
                    cell.setCellStyle(cellCenterStyle);
                }
                
                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,15));
            } else {
                for(Map<String, Object> objMap : objExcelData) {                    
                    menuRow = sheet.createRow(currentRow);
                    String fee1 = "";
                    if(objMap.get("FEE01") != "") fee1 = "%";
	            	else fee1 = ""; 
                    
                    String fee2 = "";
                    String fee2_1 = "";
	            	if(objMap.get( "FEE0202" ) != ""){
	            		fee2 += "원";
	            	}
	            	if(objMap.get( "FEE0202" ) != null && objMap.get( "FEE0202" ) != ""){
	            		fee2 += "/";
	            	}
	            	if(objMap.get("FEE0201") != ""){
	            		fee2_1 += "%";
	            	}
                    
	            	String fee3 = "";
                    if(objMap.get("FEE03") != "") fee3 = "원";
	            	else fee3 = ""; 
                    
                    String fee5 = "";
                    if(objMap.get("FEE05") != "") fee5 = "%";
	            	else fee5 = ""; 
                    
                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
                    {                            
                    	cell = menuRow.createCell(0);
                    	cell.setCellValue(objMap.get( "RNUM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(1);
                    	cell.setCellValue(objMap.get( "CO_NO" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(2);
                    	cell.setCellValue(objMap.get( "CO_NM" )==null?"":objMap.get( "CO_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(3);
                    	cell.setCellValue(objMap.get( "AGENT_CL_NM" )==null?"":objMap.get( "AGENT_CL_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(4);
                    	cell.setCellValue(objMap.get( "MID_URL" )==null?"":objMap.get( "MID_URL" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(5);
                    	cell.setCellValue(objMap.get( "AUTH_FLG_NM" )==null?"":objMap.get( "AUTH_FLG_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(6);
                    	cell.setCellValue(objMap.get( "MID" )==null?"":objMap.get( "MID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(7);
                    	cell.setCellValue(objMap.get( "MID_NM" )==null?"":objMap.get( "MID_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(8);
                    	cell.setCellValue(objMap.get( "TERM_NO" )==null?"":objMap.get( "TERM_NO" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(9);
                    	cell.setCellValue(objMap.get( "CYCLE" )==null?"":objMap.get( "CYCLE" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(10);
                    	cell.setCellValue(objMap.get( "FEE01" )==null?"":objMap.get( "FEE01" ).toString() + fee1);
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(11);
                    	cell.setCellValue(objMap.get( "FEE0202" )==null?"":(objMap.get( "FEE0202" ).toString() + fee2 +objMap.get( "FEE0201" ).toString()+ fee2_1));
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(12);
                    	cell.setCellValue(objMap.get( "FEE03" )==null?"":objMap.get( "FEE03" ).toString()+fee3);
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(13);
                    	cell.setCellValue(objMap.get( "FEE05" )==null?"":objMap.get( "FEE05" ).toString()+fee5);
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(14);
                    	cell.setCellValue(objMap.get( "VID" )==null?"":objMap.get( "VID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(15);
                    	cell.setCellValue(objMap.get( "VGRP_NM" )==null?"":objMap.get( "VGRP_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
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