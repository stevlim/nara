package egov.linkpay.ims.baseinfomgmt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egov.linkpay.ims.baseinfomgmt.dao.CardNonInstEventDAO;
import egov.linkpay.ims.baseinfomgmt.dao.ExchangeRateDAO;

@Service("cardNonInstEventService")
public class CardNonInstEventServiceImpl implements CardNonInstEventService
{
	@Resource(name="cardNonInstEventDAO")
	private CardNonInstEventDAO cardNonInstEventDAO;
	
	public int insertNoInstCardEvent(Map<String, Object> paramMap) throws Exception{
		String strInstMM = "";
		  for(int i = 2; i<37; i++) {
			  strInstMM += paramMap.get("mm_"+String.format("%02d", i)) == null ? "" : String.format("%02d", i)+":";
		  }
		  if(strInstMM.length() > 0) strInstMM = strInstMM.substring(0, strInstMM.length()-1);
		  
		  paramMap.put( "instMM", strInstMM );
		  
		return cardNonInstEventDAO.insertNoInstCardEvent(paramMap);
    }
	public int updateNoInstCardEvent(Map<String, Object> paramMap) throws Exception{
		String strInstMM = "";
		for(int i = 2; i<37; i++) {
			strInstMM += paramMap.get("mm_"+String.format("%02d", i)) == null ? "" : String.format("%02d", i)+":";
		}
		if(strInstMM.length() > 0) strInstMM = strInstMM.substring(0, strInstMM.length()-1);
	  
		paramMap.put( "instMM", strInstMM );
		return cardNonInstEventDAO.updateNoInstCardEvent(paramMap);
	}
	@Override
    public List<Map<String,Object>> selectNoInstCardEventList(Map< String, Object > paramMap) throws Exception {
    	return cardNonInstEventDAO.selectNoInstCardEventList( paramMap );
    }
	@Override
    public Object selectNoInstCardEventListTotal(Map< String, Object > paramMap) throws Exception {
    	return cardNonInstEventDAO.selectNoInstCardEventListTotal( paramMap );
    }
}
