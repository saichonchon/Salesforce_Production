public without sharing class MarketingMaterialsController 
{
	public MarketingMaterialsController()
	{
		LoadMaterials();
	}
	
	public MarketingMaterialsController(Apexpages.StandardController sc)
	{
		Id MMId = sc.getId();
		if (MMId != null)
		{
			Marketing_Material__c mm = [SELECT Source_Code__c FROM Marketing_Material__c WHERE Id = :MMId];
			MMSourceCode = mm.Source_Code__c.replace('{!PartnerId}', string.ValueOf(PartnerPortalHelper.PartnerAccount.iDev_Partner_ID__c));
		}
		else
		{
			MMSourceCode = 'Error finding Web Page';
		}
	}
	
	// Public variables used when this is loaded by the Marketing Materials Page Viewer
	public string MMSourceCode {get; set;}
	
	// Public variables used when this is loaded by the Marketing Materials page
	public string MMType {get; set;}
	public list<clsMaterial> lstMaterials {get; set;}
	public list<string> stTypes 
	{
		get
		{
			list<string> lstResults = new list<string>();
			
			Schema.DescribeFieldResult fieldResult = Marketing_Material__c.Type__c.getDescribe();
			list<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
			
			for(Schema.PicklistEntry f : ple)
			{
				lstResults.add(f.getValue());
				//options.add(new SelectOption(f.getLabel(), f.getValue()));
			} 
			
			return lstResults;
		}
	}
	
	public void LoadMaterials()
	{
		lstMaterials = new list<clsMaterial>();
		
		if (MMType == null || MMType == '')
		{
			MMType = 'Logo';
		}
		
		clsMaterial cls;
		
		// Load the Marketing Materials
		for (Marketing_Material__c mm : [SELECT Id, Name, Name__c, Type__c, Target_URL__c, Size__c, Active__c, Description__c, Source_Code__c, Text_Version__c, 
											(SELECT Id FROM Attachments WHERE ContentType like 'image%' LIMIT 1)
										FROM Marketing_Material__c
										WHERE Type__c = :MMType
										ORDER BY Type__c, View_Order__c ASC NULLS last])
		{
			cls = new clsMaterial(mm);
			lstMaterials.add(cls);
		}
	}
	
	public void SelectMarketing()
	{
		MMType = ApexPages.currentPage().getParameters().get('mmType');
		
		LoadMaterials();
	}
	
	public class clsMaterial
	{
		private Marketing_Material__c objMaterial {get; set;}
		
		public string MaterialType
		{
			get
			{
				if (objMaterial != null)
				{
					return objMaterial.Type__c;
				}
				else
				{
					return null;
				}
			} 
		}
		
		public string MaterialName 
		{
			get
			{
				if (objMaterial != null)
				{
					return objMaterial.Name__c;
				}
				else
				{
					return null;
				}
			} 
		}
		
		public string TargetURL 
		{
			get
			{
				if (objMaterial != null)
				{
					return objMaterial.Target_URL__c;
				}
				else
				{
					return null;
				}
			} 
		}
		
		public string Size 
		{
			get
			{
				if (objMaterial != null)
				{
					return objMaterial.Size__c;
				}
				else
				{
					return null;
				}
			} 
		}
		
		public string MaterialDesc
		{
			get
			{
				if (objMaterial != null)
				{
					return objMaterial.Description__c;
				}
				else
				{
					return null;
				}
			} 
		}
		
		public string SourceCode 
		{
			get
			{
				if (objMaterial != null)
				{
					if (objMaterial.Source_Code__c != null)
					{
						return objMaterial.Source_Code__c.replace('{!PartnerId}', string.ValueOf(PartnerPortalHelper.PartnerAccount.iDev_Partner_ID__c)).replace('{!PartnerFName}', (PartnerPortalHelper.CurrentUserRecord.FirstName == null ? PartnerPortalHelper.CurrentUserRecord.LastName : PartnerPortalHelper.CurrentUserRecord.FirstName));
					}
					else
					{
						return null;
					}
				}
				else
				{
					return null;
				}
			} 
			set;
		}
		
		public string TextVersion 
		{
			get
			{
				if (objMaterial != null)
				{
					if (objMaterial.Text_Version__c != null)
					{
						return objMaterial.Text_Version__c.replace('{!PartnerId}', string.ValueOf(PartnerPortalHelper.PartnerAccount.iDev_Partner_ID__c)).replace('{!PartnerFName}', (PartnerPortalHelper.CurrentUserRecord.FirstName == null ? PartnerPortalHelper.CurrentUserRecord.LastName : PartnerPortalHelper.CurrentUserRecord.FirstName));
					}
					else
					{
						return null;
					}
				}
				else
				{
					return null;
				}
			} 
			set;
		}
		
		public boolean isActive 
		{
			get
			{
				if (objMaterial != null)
				{
					return objMaterial.Active__c;
				}
				else
				{
					return null;
				}
			} 
		}
		
		public string ImageID 
		{
			get
			{
				if (objMaterial != null)
				{
					if (objMaterial.Attachments != null)
					{
						Attachment a = objMaterial.Attachments; 
						return a.Id;
					}
					else
					{
						return null;
					}
				}
				else
				{
					return null;
				}
			} 
		}
		
		public string RecordID
		{
			get
			{
				if (objMaterial != null)
				{
					return objMaterial.Id;
				}
				else
				{
					return null;
				}
			} 
		}
		
		public clsMaterial(Marketing_Material__c objMM)
		{
			objMaterial = objMM;
		}
	}
}