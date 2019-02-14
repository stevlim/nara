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
public class PgStmtListExcelGenerator extends AbstractExcelView {
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
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )0 , ( int) 0, (short )0 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )1 , ( int) 0, (short )14 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )15 , ( int) 0, (short )15 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )16 , ( int) 0, (short )19 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )20 , ( int) 0, (short )20 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )21 , ( int) 0, (short )23 ));
            	
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0655"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	
            	cell = menuRow.createCell(15);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0656"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	
            	cell = menuRow.createCell(20);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0657"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(1);
            	
            	cell = menuRow.createCell(0);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_DASHBOARD_0029"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(1);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0158"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0159"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0142"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_PW_DE_03"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_PW_DE_12"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0160"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0190"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0245"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0044"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0651"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0147"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0101"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(13);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0078"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(14);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0166"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	
            	cell = menuRow.createCell(15);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0306"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(16);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0609"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(17);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0179"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(18);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0652"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(19);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0557"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	
            	cell = menuRow.createCell(20);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0653"));
            	cell.setCellStyle(cellCenterStyle);
             	cell = menuRow.createCell(21);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0654"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(22);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0556"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(23);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0573"));
            	cell.setCellStyle(cellCenterStyle);
            }

            
            int currentRow = 2;

            if (objExcelData.isEmpty()){
                menuRow = sheet.createRow(currentRow);
                
                for(int i=0; i<24; i++) { //test 10 cnt
                    cell = menuRow.createCell(i);
                    
                    if (i == 0) {
                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
                    }
                    
                    cell.setCellStyle(cellCenterStyle);
                }
                
                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,23));
            } else {
                for(Map<String, Object> objMap : objExcelData) {                    
                    menuRow = sheet.createRow(currentRow);
                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
                    {                            
                    	
                    	cell = menuRow.createCell(0);
                    	cell.setCellValue(objMap.get( "RNUM" )==null?"":objMap.get( "RNUM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(1);
                    	cell.setCellValue(objMap.get( "APP_DT" )==null?"":objMap.get( "APP_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(2);
                    	cell.setCellValue(objMap.get( "CC_DT" )==null?"":objMap.get( "CC_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(3);
                    	cell.setCellValue(objMap.get( "CO_NM" )==null?"":objMap.get( "CO_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(4);
                    	cell.setCellValue(objMap.get( "MID" )==null?"":objMap.get( "MID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(5);
                    	cell.setCellValue(objMap.get( "TID" )==null?"":objMap.get( "TID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(6);
                    	cell.setCellValue(objMap.get( "GOODS_AMT" )==null?"":objMap.get( "GOODS_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(7);
                    	cell.setCellValue(objMap.get( "ORD_NM" )==null?"":objMap.get( "ORD_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(8);
                    	cell.setCellValue(objMap.get( "PM_NM" )==null?"":objMap.get( "PM_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(9);
                    	cell.setCellValue(objMap.get( "QUOTA_MON" )==null?"":objMap.get( "QUOTA_MON" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(10);
                    	cell.setCellValue(objMap.get( "CP_NM" )==null?"":objMap.get( "CP_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(11);
                    	cell.setCellValue(objMap.get( "SPM_NM" )==null?"":objMap.get( "SPM_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(12);
                    	cell.setCellValue(objMap.get( "TRX_CD" )=="1"?"Y":"N");
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(13);
                    	cell.setCellValue(objMap.get( "STATE_NM" )==null?"":objMap.get( "STATE_NM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(14);
                    	cell.setCellValue(objMap.get( "MBS_USR_ID" )==null?"":objMap.get( "MBS_USR_ID" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(15);
                    	cell.setCellValue(objMap.get( "ACQU_DT" )==null?"":objMap.get( "ACQU_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(16);
                    	cell.setCellValue(objMap.get( "DEPOSIT_DT" )==null?"":objMap.get( "DEPOSIT_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(17);
                    	cell.setCellValue(objMap.get( "MBS_NO" )==null?"":objMap.get( "MBS_NO" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(18);
                    	cell.setCellValue(objMap.get( "ORG_FEE" )==null?"":objMap.get( "ORG_FEE" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(19);
                    	cell.setCellValue(objMap.get( "ORG_AMT" )==null?"":objMap.get( "ORG_AMT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(20);
                    	cell.setCellValue(objMap.get( "STMT_DT" )==null?"":objMap.get( "STMT_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(21);
                    	cell.setCellValue(objMap.get( "FEE" )==null?"":objMap.get( "FEE" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(22);
                    	cell.setCellValue(objMap.get( "VAT" )==null?"":objMap.get( "VAT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(23);
                    	cell.setCellValue(objMap.get( "DPST_AMT" )==null?"":objMap.get( "DPST_AMT" ).toString());
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