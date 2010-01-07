package org.opentaps.dataimport;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;
import java.util.Map;

import javolution.util.FastList;
import javolution.util.FastMap;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.ofbiz.base.util.Debug;
import org.ofbiz.entity.GenericDelegator;
import org.ofbiz.entity.GenericEntityException;
import org.ofbiz.entity.GenericValue;
import org.ofbiz.product.spreadsheetimport.ImportProductServices;
import org.ofbiz.service.DispatchContext;
import org.ofbiz.service.ServiceUtil;

public class ProductImportFromExcelServices {
	
	  public static String module = ImportProductServices.class.getName();

	    /**
	     * @param dctx
	     * @param context
	     * @return
	     */
	    public static Map<String, Object> importProductFromExcel(DispatchContext dctx, Map<String, ? extends Object> context) {
	        GenericDelegator delegator = dctx.getDelegator();
	        Map<String, Object> responseMsgs = FastMap.newInstance();
	        // System.getProperty("user.dir") returns the path upto ofbiz home
	        // directory
	        String path = System.getProperty("user.dir") + File.separatorChar + "hot-deploy" + File.separatorChar + "dataimport" + File.separatorChar + "data" + File.separatorChar + "xls" + File.separatorChar;
	        List<File> fileItems = FastList.newInstance();

	        if (path != null && path.length() > 0) {
	            File importDir = new File(path);
	            if (importDir.isDirectory() && importDir.canRead()) {
	                File[] files = importDir.listFiles();
	                // loop for all the containing xls file in the spreadsheet
	                // directory
	                for (int i = 0; i < files.length; i++) {
	                    if (files[i].getName().toUpperCase().endsWith("XLS")) {
	                        fileItems.add(files[i]);
	                    }
	                }
	            } else {
	                Debug.logWarning("Directory not found or can't be read", module);
	                return responseMsgs;
	            }
	        } else {
	            Debug.logWarning("No path specified, doing nothing", module);
	            return responseMsgs;
	        }

	        if (fileItems.size() < 1) {
	            Debug.logWarning("No spreadsheet exists in " + path, module);
	            return responseMsgs;
	        }

	        for (File item: fileItems) {
	            // read all xls file and create workbook one by one.
	            List<Map<String, Object>> Products = FastList.newInstance();
	            POIFSFileSystem fs = null;
	            HSSFWorkbook wb = null;
	            try {
	                fs = new POIFSFileSystem(new FileInputStream(item));
	                wb = new HSSFWorkbook(fs);
	            } catch (IOException e) {
	                Debug.logError("Unable to read or create workbook from file", module);
	                return responseMsgs;
	            }

	            // get first sheet
	            HSSFSheet sheet = wb.getSheet("Products");
	            int sheetLastRowNumber = sheet.getLastRowNum();
	            for (int j = 1; j <= sheetLastRowNumber; j++) {
	                HSSFRow row = sheet.getRow(j);
	                if (row != null) {
	                    // read productId from first column "sheet column index
	                    // starts from 0"
	                    HSSFCell cell1 = row.getCell((short) 0);
	                    cell1.setCellType(HSSFCell.CELL_TYPE_STRING);
	                    String productId = cell1.getRichStringCellValue().toString();
	                    
	                    boolean productExists = ProductImportHelperFromExcel.checkProductExistsExcel(productId, delegator);

	                    if (productId != null && !productId.trim().equalsIgnoreCase("") && !productExists) 
	                        Products.add(ProductImportHelperFromExcel.prepareProduct(productId, 
	                        														row.getCell((short) 1).toString(),
	                        														row.getCell((short) 2).toString(),
	                        														row.getCell((short) 3).toString(),
	                        														row.getCell((short) 4).toString(),
	                        														row.getCell((short) 5).toString(),
	                        														row.getCell((short) 6).toString()));
	                    int rowNum = row.getRowNum() + 1;
	                    if (row.toString() != null && !row.toString().trim().equalsIgnoreCase("") && Products.size() > 0
	                                && !productExists) {
	                            Debug.logWarning("Row number " + rowNum + " not imported from " + item.getName(), module);

	                    }
	                }
	            }
	            // create and store values in "DataImportProduct"
	            // in database
	            for (int j = 0; j < Products.size(); j++) {
	                GenericValue productGV = delegator.makeValue("DataImportProduct", Products.get(j));
	                
	                if (!ProductImportHelperFromExcel.checkProductExistsExcel(productGV.getString("productId"), delegator)) {
	                    try {
	                        delegator.create(productGV);
	                    } catch (GenericEntityException e) {
	                        Debug.logError("Cannot store product", module);
	                        return ServiceUtil.returnError("Cannot store product");
	                    }
	                }
	            }
	            int uploadedProducts = Products.size() + 1;
	            if (Products.size() > 0)
	                Debug.logInfo("Imported " + uploadedProducts + " products from file " + item.getName(), module);
	        }
	        return responseMsgs;
	    }
}


