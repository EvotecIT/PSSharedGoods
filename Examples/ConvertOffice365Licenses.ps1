Import-Module PSSharedGoods -Force

Convert-Office365License -License 'VISIOCLIENT','PROJECTONLINE_PLAN_1','test'
Convert-Office365License -License "Office 365 (Plan A3) for Faculty","Office 365 (Enterprise Preview)", 'test' -ToSku