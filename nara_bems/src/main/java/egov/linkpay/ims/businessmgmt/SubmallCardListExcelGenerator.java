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
public class SubmallCardListExcelGenerator extends AbstractExcelView {
    Logger log = Logger.getLogger(this.getClass());
    
    @SuppressWarnings("unchecked")
    @Override
    protected void buildExcelDocument(Map<String, Object> objExcelMap, HSSFWorkbook workbook, HttpServletRequest req, HttpServletResponse res) throws Exception {
        String strExcelName = "";

        Map<String,Object>       objReqMap    = null;
        List<Map<String,Object>> cardInfoData    = null;
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
            cardInfoData    = (List<Map<String,Object>>) objExcelMap.get("cardLst"); //디비에서 가져온 카드 정보 값
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
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_DASHBOARD_0029"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(1);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0085"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0086"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0110"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_MM_0163"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0111"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0112"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0090"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0113"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0099"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0114"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(11);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0115"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(12);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0116"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(13);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0117"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(14);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0118"));
            	cell.setCellStyle(cellCenterStyle);
            }
            
            int currentRow = 1;

            if (objExcelData.isEmpty()){
                menuRow = sheet.createRow(currentRow);
                
                for(int i=0; i<=14; i++) { //test 10 cnt
                    cell = menuRow.createCell(i);
                    
                    if (i == 0) {
                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
                    }
                    
                    cell.setCellStyle(cellCenterStyle);
                }
                
                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,14));
            } else {
                for(Map<String, Object> objMap : objExcelData) {                    
                    menuRow = sheet.createRow(currentRow);
                        
                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
                    {                            
                    	cell = menuRow.createCell(0);
                    	cell.setCellValue(objMap.get( "RNUM" )==null?"":objMap.get( "RNUM" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(1);
                    	cell.setCellValue(objMap.get( "CONT_DT" )==null?"":objMap.get( "CONT_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(2);
                    	cell.setCellValue(objMap.get( "REQ_DT" )==null?"":objMap.get( "REQ_DT" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(3);
                    	cell.setCellValue(objMap.get("CO_NO")==null?"":objMap.get( "CO_NO" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(4);
                    	cell.setCellValue(objMap.get( "CO_URL" )==null?"":objMap.get( "CO_URL" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(5);
                    	cell.setCellValue(objMap.get( "BS_KIND" )==null?"":objMap.get( "BS_KIND" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	cell = menuRow.createCell(6);
                    	cell.setCellValue(objMap.get( "EMP" )==null?"":objMap.get( "EMP" ).toString());
                    	cell.setCellStyle(cellCenterStyle);
                    	if(cardInfoData.size() > 0){
                    		cell = menuRow.createCell(7);
                    		cell.setCellValue(cardInfoData.get( 1 ).get("status1")==null? "미등록" :cardInfoData.get( 1 ).get( "status1" ).toString());
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(8);
                    		cell.setCellValue(objMap.get("CP_CD")=="01"?objMap.get( "SNAME" ).toString() : "미등록");
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(9);
                    		cell.setCellValue(objMap.get("CP_CD")=="06"?objMap.get( "SNAME" ).toString() : "미등록");
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(10);
                    		cell.setCellValue(objMap.get("CP_CD")=="08"?objMap.get( "SNAME" ).toString() : "미등록");
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(11);
                    		cell.setCellValue(objMap.get("CP_CD")=="07"?objMap.get( "SNAME" ).toString() : "미등록");
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(12);
                    		cell.setCellValue(objMap.get("CP_CD")=="03"?objMap.get( "SNAME" ).toString() : "미등록");
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(13);
                    		cell.setCellValue(objMap.get("CP_CD")=="04"?objMap.get( "SNAME" ).toString() : "미등록"); 
                    		cell.setCellStyle(cellCenterStyle);
                    		cell = menuRow.createCell(14);
                    		cell.setCellValue(objMap.get("CP_CD")=="12"?objMap.get( "SNAME" ).toString() : "미등록");
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