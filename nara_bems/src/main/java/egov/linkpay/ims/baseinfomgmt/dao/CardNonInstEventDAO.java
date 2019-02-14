package egov.linkpay.ims.baseinfomgmt.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("cardNonInstEventDAO")
public class CardNonInstEventDAO extends BaseDAO
{
	public int insertNoInstCardEvent(Map< String, Object > dataMap) throws Exception {
		int cnt = (Integer)insert("cardNonInstEvent.insertNoInstCardEvent", dataMap);
		return cnt;
	}
	public int updateNoInstCardEvent(Map< String, Object > dataMap) throws Exception {
		int cnt = (Integer)insert("cardNonInstEvent.updateNoInstCardEvent", dataMap);
		return cnt;
	}
	@SuppressWarnings( "unchecked" )
	public List<Map<String, Object>> selectNoInstCardEventList(Map< String, Object > paramMap) throws Exception {
		return selectList( "cardNonInstEvent.selectNoInstCardEventList", paramMap);
    }
	public Object selectNoInstCardEventListTotal(Map< String, Object > paramMap) throws Exception {
		return selectOne( "cardNonInstEvent.selectNoInstCardEventListTotal", paramMap);
    }
}
