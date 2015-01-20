package owltools.gaf.lego.server.handler;

import static org.junit.Assert.*;
import static owltools.gaf.lego.MolecularModelJsonRenderer.*;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;
import org.semanticweb.owlapi.model.OWLObjectProperty;

import owltools.gaf.lego.MolecularModelJsonRenderer.KEY;
import owltools.gaf.lego.UndoAwareMolecularModelManager;
import owltools.gaf.lego.server.handler.M3BatchHandler.Entity;
import owltools.gaf.lego.server.handler.M3BatchHandler.M3Argument;
import owltools.gaf.lego.server.handler.M3BatchHandler.M3BatchResponse;
import owltools.gaf.lego.server.handler.M3BatchHandler.M3Request;
import owltools.gaf.lego.server.handler.M3BatchHandler.Operation;
import owltools.graph.OWLGraphWrapper;
import owltools.io.CatalogXmlIRIMapper;
import owltools.io.ParserWrapper;

public class Examples {
	
	private static OWLGraphWrapper graph = null;
	private static UndoAwareMolecularModelManager models = null;
	private static JsonOrJsonpBatchHandler handler = null;

	@Rule
	public TemporaryFolder folder = new TemporaryFolder();

	private static final String uid = "test-user";
	private static final String intention = "test-intention";
	private static final String packetId = "foo-packet-id";

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		ParserWrapper pw = new ParserWrapper();
		pw.addIRIMapper(new CatalogXmlIRIMapper("../examples/catalog-v001.xml"));
		graph = pw.parseToOWLGraph("../examples/minerva-importer.owl");
		
		models = new UndoAwareMolecularModelManager(graph);
		JsonOrJsonpBatchHandler.ADD_INFERENCES = true;
		JsonOrJsonpBatchHandler.USE_CREATION_DATE = true;
		JsonOrJsonpBatchHandler.USE_USER_ID = true;
		handler = new JsonOrJsonpBatchHandler(models, Collections.<OWLObjectProperty>emptySet(), null);
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
		if (handler != null) {
			handler = null;
		}
		if (models != null) {
			models.dispose();
			models = null;
		}
		if (graph != null) {
			// should not be necessary but do it to be sure
			graph.close();
			graph = null;
		}
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Test
	public void testExample1() {
		final String modelId = generateBlankModel();
		
		// create two individuals
		// individual for disease OMIM:100050
		M3Request[] batch1 = new M3Request[1];
		batch1[0] = new M3Request();
		batch1[0].entity = Entity.individual.name();
		batch1[0].operation = Operation.create.getLbl();
		batch1[0].arguments = new M3Argument();
		batch1[0].arguments.modelId = modelId;
		batch1[0].arguments.subject = "OMIM:100050";

		M3BatchResponse resp1 = handler.m3Batch(uid, intention, packetId, batch1, true);
		assertEquals(resp1.message, M3BatchResponse.MESSAGE_TYPE_SUCCESS, resp1.message_type);
		String individual1 = null;
		List<Map<Object, Object>> iObjs1 = (List) resp1.data.get(KEY_INDIVIDUALS);
		assertEquals(1, iObjs1.size());
		for(Map<Object, Object> iObj : iObjs1) {
			individual1 = (String) iObj.get(KEY.id);
		}

		// individual for phenotype HP:0000028
		M3Request[] batch2 = new M3Request[1];
		batch2[0] = new M3Request();
		batch2[0] = new M3Request();
		batch2[0].entity = Entity.individual.name();
		batch2[0].operation = Operation.create.getLbl();
		batch2[0].arguments = new M3Argument();
		batch2[0].arguments.modelId = modelId;
		batch2[0].arguments.subject = "HP:0000028";

		M3BatchResponse resp2 = handler.m3Batch(uid, intention, packetId, batch2, true);
		assertEquals(resp2.message, M3BatchResponse.MESSAGE_TYPE_SUCCESS, resp2.message_type);
		String individual2 = null;
		List<Map<Object, Object>> iObjs2 = (List) resp2.data.get(KEY_INDIVIDUALS);
		assertEquals(1, iObjs2.size());
		for(Map<Object, Object> iObj : iObjs2) {
			individual2 = (String) iObj.get(KEY.id);
		}

		// create relation
		M3Request[] batch3 = new M3Request[1];
		batch3[0] = new M3Request();
		batch3[0].entity = Entity.edge.name();
		batch3[0].operation = Operation.add.getLbl();
		batch3[0].arguments = new M3Argument();
		batch3[0].arguments.modelId = modelId;
		batch3[0].arguments.subject = individual1;
		batch3[0].arguments.object = individual2;
		batch3[0].arguments.predicate = "RO:0002200";

		M3BatchResponse resp3 = handler.m3Batch(uid, intention, packetId, batch3, true);
		assertEquals(resp3.message, M3BatchResponse.MESSAGE_TYPE_SUCCESS, resp3.message_type);
	}

	
	/**
	 * @return modelId
	 */
	private String generateBlankModel() {
		// create blank model
		M3Request[] batch = new M3Request[1];
		batch[0] = new M3Request();
		batch[0].entity = Entity.model.name();
		batch[0].operation = Operation.generateBlank.getLbl();
		M3BatchResponse resp1 = handler.m3Batch(uid, intention, null, batch, true);
		assertEquals(resp1.message, M3BatchResponse.MESSAGE_TYPE_SUCCESS, resp1.message_type);
		assertNotNull(resp1.packet_id);
		String modelId = (String) resp1.data.get("id");
		assertNotNull(modelId);
		return modelId;
	}
}
