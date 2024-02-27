INSERT INTO  ${LOOKER_DB}.${TARGET_TABLE}(
                DAY_KEY,
                TY_DATE,
                LY_DATE,
                MTH_KEY,
                STR_DESC,
                COUNTRY_CDE,
                LOC_KEY,
                LOC_ID,
                LOC_STORE_REG,
                DY_LOC_STORE_ID,
                DY_COMP_NONCOMP,
                CHNL_DESC,
                CHNL_ID,
                DY_STORE_CATAGORY,
                DY_STORE_TYPE,
                DY_FLASH_SLS_STORE_STATUS,
                DY_LOC_PARENT_KEY,
                DY_BOSS_TXN_FLG,
                DY_PRSNL_SHPR_FLG,
                FACT_SOURCE,
                STR_TYP_CDE_DESC,
                DY_COMPANY_CDE,
                STR_NAME,
                PARAM_VALUE,
                RTL_FLG,
                RTL_FP_FLG,
                RTL_OP_FLG,
                RTL_FP_CMP_FLG,
                RTL_FP_NW_FLG,
                RTL_FP_NCMP_FLG,
                RTL_FP_CLZ_FLG,
                RTL_OP_CMP_FLG,
                RTL_OP_NW_FLG,
                RTL_OP_NCMP_FLG,
                RTL_OP_CLZ_FLG,
                SAKS_FLG,
                DY_COM_FLG,
                ECOM_FLG,
                OMNI_FLG,
				--LOG-SG-20240215:Concession Related Columns
				CNCSN_NW_FLG,
				CNCSN_CMP_FLG,
				CNCSN_NCMP_FLG,
				CNCSN_CLZ_FLG,
                CNCSN_FLG,
                DTD_SLS_RTL_LCL,
                LY_DTD_SLS_RTL_LCL,
                TY_WTD_SLS_RTL_LCL,
                LY_WTD_SLS_RTL_LCL,
                TY_MTD_SLS_RTL_LCL,
                LY_MTD_SLS_RTL_LCL,
                TY_YTD_SLS_RTL_LCL,
                LY_YTD_SLS_RTL_LCL,
                DTD_SLS_RTL_USD,
                LY_DTD_SLS_RTL_USD,
                TY_WTD_SLS_RTL_USD,
                LY_WTD_SLS_RTL_USD,
                TY_MTD_SLS_RTL_USD,
                LY_MTD_SLS_RTL_USD,
                TY_YTD_SLS_RTL_USD,
                LY_YTD_SLS_RTL_USD,
                DTD_SLS_CNT,
                TY_WTD_SLS_CNT,
                TY_MTD_SLS_CNT,
                TY_YTD_SLS_CNT,
                LY_DTD_SLS_CNT,
                LY_WTD_SLS_CNT,
                LY_MTD_SLS_CNT,
                LY_YTD_SLS_CNT,
                DTD_SLS_QTY,
                TY_WTD_SLS_QTY,
                TY_MTD_SLS_QTY,
                TY_YTD_SLS_QTY,
                TY_WTD_PLN_LCL,
                TY_MTD_PLN_LCL,
                TY_YTD_PLN_LCL,
                TY_WTD_PLN_USD,
                TY_MTD_PLN_USD,
                TY_YTD_PLN_USD,
                DTD_TRFC,
                TY_WTD_TRFC,
                TY_MTD_TRFC,
                TY_YTD_TRFC,
                LY_DTD_TRFC,
                LY_WTD_TRFC,
                LY_MTD_TRFC,
                LY_YTD_TRFC
   ) (SELECT
                    Base.DAY_KEY                                        DAY_KEY
                    ,Base.TY_Date                                       TY_DATE
                    ,Base.LY_Date                                       LY_DATE
                    ,Base.MTH_KEY
                    ,Base.DY_LOC_STORE_DESC                             STR_DESC
                    ,Base.LOC_COUNTRY_CDE                               COUNTRY_CDE
                    ,Base.LOC_KEY                                       LOC_KEY
                    ,Base.LOC_ID                                        LOC_ID
                    ,Base.DY_LOC_STORE_REG                                LOC_STORE_REG
                    ,Base.DY_LOC_STORE_ID                                 DY_LOC_STORE_ID
                    ,Base.DY_COMP_NONCOMP
                    ,Base.CHNL_DESC
                    ,Base.CHNL_ID
                    ,Base.DY_STORE_CATAGORY
                    ,Base.DY_STORE_TYPE
                    ,Base.DY_FLASH_SLS_STORE_STATUS
                    ,Base.DY_LOC_PARENT_KEY
                    ,Base.DY_BOSS_TXN_FLG
                    ,Base.DY_PRSNL_SHPR_FLG
                    ,Base.FACT_SOURCE
                    ,Base.STR_TYP_CDE_DESC
		    ,Base.DY_COMPANY_CDE
            ,CONCAT(Base.DY_LOC_STORE_ID ,'-',Base.DY_LOC_STORE_DESC)  STR_NAME
            ,PARAM_VALUE
			,-- LOG-SG-20230531: 1.RETAIL
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE') THEN FALSE ELSE TRUE END)--SG20240215: Replaced 'SKS' with 'MARKETPLACE' as marketplace general flow naming convension of (Retail)+'MARKETPLACE'
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE', 'OFF PRICE')), FALSE)
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE', 'OFF PRICE')), FALSE)
    THEN 1
  ELSE 0
END AS RTL_FLG

,-- LOG-SG-20230531: 2.RETAIL FP
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    THEN 1
  ELSE 0
END AS RTL_FP_FLG
,-- LOG-SG-20230531: 3.RETAIL OP
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)

    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    THEN 1
  ELSE 0
END AS RTL_OP_FLG
,-- LOG-SG-20230531: 4.RETAIL FP COMP
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'COMP')
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'COMP')
    THEN 1
  ELSE 0
END AS RTL_FP_CMP_FLG

,-- LOG-SG-20230531: 5.RETAIL FP NEW
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NEW')
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NEW')
    THEN 1
  ELSE 0
END AS RTL_FP_NW_FLG
,-- LOG-SG-20230531: 6.RETAIL FP NON COMP
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NON-COMP')
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NON-COMP')
    THEN 1
  ELSE 0
END AS RTL_FP_NCMP_FLG
,-- LOG-SG-20230531: 7.RETAIL FP CLOSED
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'CLOSED')
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'CLOSED')
    THEN 1
  ELSE 0
END AS RTL_FP_CLZ_FLG
,-- LOG-SG-20230531: 8.RETAIL OP COMP
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'COMP')
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'COMP')
    THEN 1
  ELSE 0
END AS RTL_OP_CMP_FLG

,-- LOG-SG-20230531: 9.RETAIL OP NEW
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NEW')
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NEW')
    THEN 1
  ELSE 0
END AS RTL_OP_NW_FLG
,-- LOG-SG-20230531: 10.RETAIL OP NON COMP
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NON-COMP')
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NON-COMP')
    THEN 1
  ELSE 0
END AS RTL_OP_NCMP_FLG
,-- LOG-SG-20230531: 11.RETAIL OP CLOSED
CASE
  WHEN
    FACT_SOURCE=999
    AND CHNL_ID=1
    AND DY_BOSS_TXN_FLG <>1
    AND DY_PRSNL_SHPR_FLG<>1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'CLOSED')
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=1
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    AND IFNULL((Base.DY_STORE_TYPE IN ('OFF PRICE')), FALSE)
    AND (Base.DY_FLASH_SLS_STORE_STATUS = 'CLOSED')
    THEN 1
  ELSE 0
END AS RTL_OP_CLZ_FLG
,-- LOG-SG-20230531: 12.MARKETPLACE
CASE WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'MARKETPLACE') THEN 1 ELSE 0 END AS MARKETPLACE_FLG
,-- LOG-SG-20230531: 13.DY.COM
CASE
  WHEN
    FACT_SOURCE=999
    AND (CHNL_ID=2
    OR DY_BOSS_TXN_FLG ='1'
    OR DY_PRSNL_SHPR_FLG='1' )
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND CHNL_ID=2
    AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE','CONCESSION') THEN FALSE ELSE TRUE END)
    THEN 1
  ELSE 0
END AS DY_COM_FLG
,-- LOG-SG-20230531: 14.ECOM
CASE
  WHEN
    FACT_SOURCE=999
    AND (CHNL_ID=2
    OR DY_BOSS_TXN_FLG ='1'
    OR DY_PRSNL_SHPR_FLG='1'
    OR (CASE WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'MARKETPLACE') THEN TRUE ELSE FALSE END))
    THEN 1
  WHEN
    FACT_SOURCE=9999
    AND (CHNL_ID=2
    OR (CASE WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'MARKETPLACE') THEN TRUE ELSE FALSE END))
    THEN 1
  ELSE 0
END AS ECOM_FLG
,-- LOG-SG-20230531: 15.OMNI
CASE
  WHEN
    (
      CASE
        WHEN
          FACT_SOURCE=999
          AND CHNL_ID=1
          AND DY_BOSS_TXN_FLG <>1
          AND DY_PRSNL_SHPR_FLG<>1
          AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE') THEN FALSE ELSE TRUE END)
          AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE', 'OFF PRICE')), FALSE)
          THEN TRUE
        WHEN
          FACT_SOURCE=9999
          AND CHNL_ID=1
          AND (CASE WHEN UPPER(LTRIM(Base.DY_STORE_CATAGORY)) LIKE ANY ('MARKETPLACE') THEN FALSE ELSE TRUE END)
          AND IFNULL((Base.DY_STORE_TYPE IN ('FULL PRICE', 'OFF PRICE')), FALSE)
          THEN TRUE
        ELSE FALSE
      END
    )
    OR
    (
      CASE
        WHEN
          FACT_SOURCE=999
          AND (CHNL_ID=2
          OR DY_BOSS_TXN_FLG ='1'
          OR DY_PRSNL_SHPR_FLG='1'
          OR (CASE WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'MARKETPLACE') THEN TRUE ELSE FALSE END))
          THEN TRUE
        WHEN
          FACT_SOURCE=9999
          AND (CHNL_ID=2
          OR (CASE WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'MARKETPLACE') THEN TRUE ELSE FALSE END))
          THEN TRUE
        ELSE FALSE
    END
    )
    THEN 1
  ELSE 0
END AS OMNI_FLG
--LOG-SG-20240215: Consession Soted added as Sales Flash Phase2
--16. Concession New
,CASE
	WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'CONCESSION')
	AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NEW')
		THEN 1
	ELSE 0
END AS CNCSN_NW_FLG
--17. Concession Comp
,CASE
	WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'CONCESSION')
	AND (Base.DY_FLASH_SLS_STORE_STATUS = 'COMP')
		THEN 1
	ELSE 0
END AS CNCSN_CMP_FLG
--18. Concession Non-Comp
,CASE
	WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'CONCESSION')
	AND (Base.DY_FLASH_SLS_STORE_STATUS = 'NON-COMP')
		THEN 1
	ELSE 0
END AS CNCSN_NCMP_FLG
--19. Concession closed
,CASE
	WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'CONCESSION')
	AND (Base.DY_FLASH_SLS_STORE_STATUS = 'CLOSED')
		THEN 1
	ELSE 0
END AS CNCSN_CLZ_FLG
--20. Concession
,CASE
	WHEN CONTAINS(UPPER(LTRIM(Base.DY_STORE_CATAGORY)),'CONCESSION')
		THEN 1
	ELSE 0
END AS CNCSN_FLG
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS' THEN Base.F_FACT_RTL_LCL ELSE NULL END)) AS DTD_SLS_RTL_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_LY' THEN Base.F_FACT_RTL_LCL ELSE NULL END)) AS LY_DTD_SLS_RTL_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_WTD' THEN Base.F_FACT_RTL_LCL ELSE NULL END)) AS TY_WTD_SLS_RTL_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_WTD_LY' THEN Base.F_FACT_RTL_LCL ELSE NULL END)) AS LY_WTD_SLS_RTL_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_MTD' THEN Base.F_FACT_RTL_LCL ELSE NULL END)) AS TY_MTD_SLS_RTL_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_MTD_LY' THEN Base.F_FACT_RTL_LCL ELSE NULL END)) AS LY_MTD_SLS_RTL_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_YTD' THEN Base.F_FACT_RTL_LCL ELSE NULL END)) AS TY_YTD_SLS_RTL_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_YTD_LY' THEN Base.F_FACT_RTL_LCL ELSE NULL END)) AS LY_YTD_SLS_RTL_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS' THEN Base.F_FACT_RTL ELSE NULL END)) AS DTD_SLS_RTL_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_LY' THEN Base.F_FACT_RTL ELSE NULL END)) AS LY_DTD_SLS_RTL_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_WTD' THEN Base.F_FACT_RTL ELSE NULL END)) AS TY_WTD_SLS_RTL_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_WTD_LY' THEN Base.F_FACT_RTL ELSE NULL END)) AS LY_WTD_SLS_RTL_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_MTD' THEN Base.F_FACT_RTL ELSE NULL END)) AS TY_MTD_SLS_RTL_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_MTD_LY' THEN Base.F_FACT_RTL ELSE NULL END)) AS  LY_MTD_SLS_RTL_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_YTD' THEN Base.F_FACT_RTL ELSE NULL END)) AS TY_YTD_SLS_RTL_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule = 'SLS_YTD_LY' THEN Base.F_FACT_RTL ELSE NULL END)) AS LY_YTD_SLS_RTL_USD

,COUNT( DISTINCT CASE WHEN Base.Time_Rule = 'SLS' AND Base.F_FACT_QTY>0  THEN  Base.TXN_ID ELSE NULL END) AS DTD_SLS_CNT
,COUNT( DISTINCT CASE WHEN Base.Time_Rule = 'SLS_WTD' AND Base.F_FACT_QTY>0  THEN  Base.TXN_ID ELSE NULL END) AS TY_WTD_SLS_CNT
,COUNT( DISTINCT CASE WHEN Base.Time_Rule = 'SLS_MTD' AND Base.F_FACT_QTY>0  THEN  Base.TXN_ID ELSE NULL END) AS TY_MTD_SLS_CNT
,COUNT( DISTINCT CASE WHEN Base.Time_Rule = 'SLS_YTD' AND Base.F_FACT_QTY>0  THEN  Base.TXN_ID ELSE NULL END) AS TY_YTD_SLS_CNT

,COUNT( DISTINCT CASE WHEN Base.Time_Rule = 'SLS_LY' AND Base.F_FACT_QTY>0  THEN  Base.TXN_ID ELSE NULL END) AS LY_DTD_SLS_CNT
,COUNT( DISTINCT CASE WHEN Base.Time_Rule = 'SLS_WTD_LY' AND Base.F_FACT_QTY>0  THEN  Base.TXN_ID ELSE NULL END) AS LY_WTD_SLS_CNT
,COUNT( DISTINCT CASE WHEN Base.Time_Rule = 'SLS_MTD_LY' AND Base.F_FACT_QTY>0  THEN  Base.TXN_ID ELSE NULL END) AS LY_MTD_SLS_CNT
,COUNT( DISTINCT CASE WHEN Base.Time_Rule = 'SLS_YTD_LY' AND Base.F_FACT_QTY>0  THEN  Base.TXN_ID ELSE NULL END) AS LY_YTD_SLS_CNT

,SUM(CASE WHEN Base.Time_Rule = 'SLS'  THEN Base.F_FACT_QTY ELSE NULL END) DTD_SLS_QTY
,SUM(CASE WHEN Base.Time_Rule = 'SLS_WTD'  THEN Base.F_FACT_QTY ELSE NULL END) TY_WTD_SLS_QTY
,SUM(CASE WHEN Base.Time_Rule = 'SLS_MTD'  THEN Base.F_FACT_QTY ELSE NULL END) TY_MTD_SLS_QTY
,SUM(CASE WHEN Base.Time_Rule = 'SLS_YTD'  THEN Base.F_FACT_QTY ELSE NULL END) TY_YTD_SLS_QTY

,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_WTD' THEN Base.omni_local_forecast END )) AS TY_WTD_PLN_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_MTD' THEN Base.omni_local_forecast END )) AS TY_MTD_PLN_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_YTD' THEN Base.omni_local_forecast END )) AS TY_YTD_PLN_LCL
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_WTD' THEN Base.omni_base_forecast END )) AS TY_WTD_PLN_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_MTD' THEN Base.omni_base_forecast END )) AS TY_MTD_PLN_USD
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_YTD' THEN Base.omni_base_forecast END )) AS TY_YTD_PLN_USD

,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS' THEN Base.TRAFFIC END )) AS DTD_TRFC
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_WTD' THEN Base.TRAFFIC END )) AS TY_WTD_TRFC
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_MTD' THEN Base.TRAFFIC END )) AS TY_MTD_TRFC
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_YTD' THEN Base.TRAFFIC END )) AS TY_YTD_TRFC
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_LY' THEN Base.TRAFFIC END )) AS LY_DTD_TRFC
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_WTD_LY' THEN Base.TRAFFIC END )) AS LY_WTD_TRFC
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_MTD_LY' THEN Base.TRAFFIC END )) AS LY_MTD_TRFC
,ZEROIFNULL(SUM(CASE WHEN Base.Time_Rule='SLS_YTD_LY' THEN Base.TRAFFIC END )) AS LY_YTD_TRFC
                
                FROM
                (
                SELECT
                Location.LOC_KEY
                ,Location.LOC_ID
                ,Location.CHNL_DESC
                ,Location.CHNL_ID
                ,Location.DY_LOC_STORE_DESC
                ,Location.LOC_COUNTRY_CDE
                ,Location.LOC_DESC
                ,Location.DY_LOC_STORE_REG
                ,Location.DY_EBS_ENTITY_CODE
                ,Location.DY_LOC_STORE_ID
                ,Location.DY_STORE_CATAGORY
                ,Location.DY_STORE_TYPE
                ,Location.DY_COMP_NONCOMP
                ,Location.DY_FLASH_SLS_STORE_STATUS
                ,Location.DY_LOC_PARENT_KEY
                ,Facts.EVENT_DAY_KEY
                ,Facts.TXN_ID
                ,Facts.TXN_LN_ID
                ,Facts.DY_PRSNL_SHPR_FLG
                ,Facts.DY_BOSS_TXN_FLG
                ,Time_Rule_Mtrx.Time_Rule
                ,Time_Rule_Mtrx.Time_Rule_Code
                ,Calendar.Date_Desc
                ,Calendar.DAY_KEY
                ,Calendar.DAY_DESC
                ,Calendar.MTH_DESC
                ,Calendar.MTH_KEY
                ,Calendar.QTR_DESC
                ,Calendar.WK_DESC
                ,Calendar.YR_KEY
                ,Calendar.TY_Date
                ,Calendar.LY_Date
                ,FACT_SOURCE
                ,STR_TYP_CDE_DESC
                ,Facts.DY_TXN_LN_TYP
				,DY_COMPANY_CDE
                ,SUM(Facts.F_FACT_RTL) AS F_FACT_RTL
                ,SUM(Facts.F_FACT_RTL_LCL) AS F_FACT_RTL_LCL
                ,SUM(Facts.F_FACT_QTY) AS F_FACT_QTY
                ,SUM(Facts.omni_local_forecast) AS omni_local_forecast
                ,SUM(Facts.TRAFFIC) AS TRAFFIC
                ,SUM(Facts.omni_base_forecast) AS omni_base_forecast
                FROM
                (
                    SELECT
                    SRC.TXN_DT_KEY  AS EVENT_DAY_KEY
                    ,SRC.TXN_LN_ID
                    ,SRC.RTRN_FLG
                    ,SRC.TXN_ID
                    ,SRC.LCL_CNCY_CDE
                    ,SRC.F_SLS_RTL  AS F_FACT_RTL
                    ,SRC.F_SLS_RTL_LCL AS F_FACT_RTL_LCL
                    ,SRC.F_SLS_QTY AS F_FACT_QTY
                    ,SRC.DY_TXN_LN_TYP
                    ,SRC.DY_PRSNL_SHPR_FLG
                    ,SRC.DY_BOSS_TXN_FLG
                    ,LOCATTR.DY_LOC_PARENT_KEY
                    ,NULL omni_local_forecast
                    ,NULL omni_base_forecast
                    ,NULL TRAFFIC
                    ,999  FACT_SOURCE
                    FROM ${ROBLING_VIEW_DB}.V_DWH_F_SLS_TXN_LN_ITM_B SRC
                    INNER JOIN ${ROBLING_VIEW_DB}.V_DWH_D_ORG_LOC_LU LOC
                    ON (SRC.DY_TXN_LOC_KEY=LOC.LOC_KEY)
                    INNER JOIN ${TABLEAU_VIEW_DB}.DV_DY_D_SALES_FLASH_ORG_LOC_ATTR_LU LOCATTR
                    ON  (LOCATTR.LOC_KEY=LOC.LOC_KEY)
                    INNER JOIN ${ROBLING_VIEW_DB}.V_DWH_D_TIM_DAY_LU DAY
                    ON (
                    SRC.DAY_KEY = DAY.DAY_KEY
                    AND DAY.YR_KEY BETWEEN (SELECT YEAR(CURR_DAY + INTERVAL '-2 YEAR')
                    FROM ${ROBLING_VIEW_DB}.V_DWH_D_CURR_TIM_LU CURR)
                    AND (SELECT YEAR(CURR_DAY) FROM ${ROBLING_VIEW_DB}.V_DWH_D_CURR_TIM_LU CURR)
                    )
                    WHERE  DY_NMERCH_ITM_DESC is NULL
                    and LOCATTR.dy_loc_store_id not in (1001,1002,1004,1007,851,808,0,999,998)
					AND NOT (UPPER(NVL(DY_INVC_PRD_DESC,'') ) LIKE ANY ('DISCOUNT LINE%','DUTY LINE%','MANUAL.%','%RESTOCK FEE%','%TAX LINE%','MISC.%','%PROMO%') AND CHNL_ID=2)
                    UNION ALL
                    SELECT
                    fc.forecast_date AS EVENT_DAY_KEY
                    ,NULL  TXN_LN_ID
                    ,NULL  RTRN_FLG
                    ,NULL  TXN_ID
                    ,NULL  LCL_CNCY_CDE
                    ,NULL   AS F_FACT_RTL
                    ,NULL   AS F_FACT_RTL_LCL
                    ,NULL AS F_FACT_QTY
                    ,NULL  DY_TXN_LN_TYP
                    ,NULL  DY_PRSNL_SHPR_FLG
                    ,NULL  DY_BOSS_TXN_FLG
                    ,PRNT.DY_LOC_PARENT_KEY
                    ,CASE WHEN (fc.local_base_flag = 'LOCAL') THEN fc.forecast_value*-1 END AS omni_local_forecast
                    ,CASE WHEN (fc.local_base_flag = 'BASE') THEN fc.forecast_value*-1 END AS omni_base_forecast
                    ,NULL TRAFFIC
                    ,9999 FACT_SOURCE
                    FROM ${DY_VIEW_DB}.V_DY_F_RETAIL_SALES_FORECAST  fc
                    ,${TABLEAU_VIEW_DB}.DV_DY_D_SALES_FLASH_LOC_PARENT_LU PRNT
                    WHERE 1=1
                    AND (fc.reporting_entity = PRNT.DY_EBS_ENTITY_CODE)
                    AND fc.current_flag IN ('Y')
                    AND fc.forecast_value <>0
                    AND fc.forecast_value IS NOT NULL

                UNION ALL
                
                    SELECT
                    TRFIC.TRAFFIC_DATE DAY_KEY
                    ,NULL  TXN_LN_ID
                    ,NULL  RTRN_FLG
                    ,NULL  TXN_ID
                    ,NULL  LCL_CNCY_CDE
                    ,NULL   AS F_FACT_RTL
                    ,NULL   AS F_FACT_RTL_LCL
                    ,NULL AS F_FACT_QTY
                    ,NULL  DY_TXN_LN_TYP
                    ,NULL  DY_PRSNL_SHPR_FLG
                    ,NULL  DY_BOSS_TXN_FLG
                    ,LOCATTR.DY_LOC_PARENT_KEY
                    ,NULL omni_local_forecast
                    ,NULL omni_base_forecast
                    ,TRFIC.TRAFFIC_COUNT AS TRAFFIC
                    ,9999 FACT_SOURCE
                    FROM ${DY_VIEW_DB}.V_DY_F_RETAIL_TRAFFIC TRFIC
                    ,${ROBLING_VIEW_DB}.V_DWH_D_ORG_LOC_LU LOC
                    ,${TABLEAU_VIEW_DB}.DV_DY_D_SALES_FLASH_ORG_LOC_ATTR_LU LOCATTR
                    WHERE ( TRFIC.KWI_STORE_NBR=loc.loc_id
                    AND (LOC.LOC_KEY = LOCATTR.LOC_KEY)
                    AND TRFIC.TRAFFIC_COUNT <>0
                    AND TRFIC.TRAFFIC_COUNT IS NOT NULL
                    )
                ) Facts
                INNER JOIN
                (
                SELECT
                MAX(LOC.LOC_KEY) AS LOC_KEY
                ,MAX(LOC.LOC_ID) AS LOC_ID
                ,MAX(LOC.CHNL_DESC) AS CHNL_DESC
                ,MAX(LOC.CHNL_ID) AS CHNL_ID
                ,MAX(LOCATTR.DY_LOC_STORE_DESC) AS DY_LOC_STORE_DESC
                ,MAX(LOCATTR.LOC_DESC) AS LOC_DESC
                ,MAX(LOC.LOC_COUNTRY_CDE) AS LOC_COUNTRY_CDE
                ,MAX(LOCATTR.DY_LOC_STORE_REG) AS DY_LOC_STORE_REG
                ,MAX(LOCATTR.DY_EBS_ENTITY_CODE) AS DY_EBS_ENTITY_CODE
                ,MAX(LOCATTR.DY_LOC_STORE_ID) AS DY_LOC_STORE_ID
                ,MAX(LOCATTR.DY_STORE_CATAGORY) AS DY_STORE_CATAGORY
                ,MAX(LOCATTR.DY_STORE_TYPE) AS DY_STORE_TYPE
                ,MAX(LOCATTR.DY_COMP_NONCOMP) AS DY_COMP_NONCOMP
                ,MAX(LOCATTR.DY_FLASH_SLS_STORE_STATUS) AS DY_FLASH_SLS_STORE_STATUS
                ,MAX(STR_TYP_CDE_DESC) AS STR_TYP_CDE_DESC
				,MAX(LOC.DY_COMPANY_CDE) AS DY_COMPANY_CDE
                ,LOCATTR.DY_LOC_PARENT_KEY
                FROM ${ROBLING_VIEW_DB}.V_DWH_D_ORG_LOC_LU LOC
                LEFT JOIN ${TABLEAU_VIEW_DB}.DV_DY_D_SALES_FLASH_ORG_LOC_ATTR_LU LOCATTR
                ON LOC.LOC_KEY = LOCATTR.LOC_KEY
                    GROUP BY LOCATTR.DY_LOC_PARENT_KEY
                )Location
                ON(Location.DY_LOC_PARENT_KEY=Facts.DY_LOC_PARENT_KEY)
                LEFT JOIN
                (
                SELECT
                M.MEAS_CDE Time_Rule
                , M.MEAS_TIM_RULE_CDE AS Time_Rule_Code
                , M.FACT_CDE
                , DAY.DAY_KEY
                FROM ${LOOKER_VIEW_DB}.V_DM_D_MEAS_FACT_TIM_RULE_MTX M
                JOIN ${ROBLING_VIEW_DB}.V_DWH_D_TIM_DAY_LU DAY
                WHERE M.FACT_CDE = 110
                    AND MEAS_TIM_RULE_CDE IN(10,15,30,35,40,45,70,75)
                    AND DAY.YR_KEY BETWEEN (
                                SELECT YEAR(CURR_DAY + INTERVAL '-2 YEAR')
                                FROM ${ROBLING_VIEW_DB}.V_DWH_D_CURR_TIM_LU CURR
                                )
                        AND (
                                SELECT YEAR(CURR_DAY)
                                FROM ${ROBLING_VIEW_DB}.V_DWH_D_CURR_TIM_LU CURR
                                )

                )Time_Rule_Mtrx
                ON(Time_Rule_Mtrx.DAY_KEY=Facts.EVENT_DAY_KEY)
                LEFT JOIN
                (
                SELECT
                MEAS_DT
                , DAY_KEY
                ,MEAS_TIM_RULE_CDE
                FROM ${LOOKER_VIEW_DB}.DV_DM_D_MEAS_TIM_RULE_DAY_MTX MTX
                WHERE 1=1
                AND MEAS_TIM_RULE_CDE IN(10,15,30,35,40,45,70,75)
                AND DAY_KEY = (SELECT CURR_DAY FROM ${ROBLING_VIEW_DB}.V_DWH_D_CURR_TIM_LU)
                )Day_Metrics
                ON(Time_Rule_Mtrx.DAY_KEY=Day_Metrics.MEAS_DT AND Time_Rule_Mtrx.Time_Rule_Code=Day_Metrics.MEAS_TIM_RULE_CDE)
                LEFT JOIN
                (
                SELECT DAY.DAY_DESC
                    , DAY.DAY_OF_WK
                    , DAY.DAY_OF_YR
                    , DAY.HALFYR_KEY
                    , DAY.HALFYR_DESC
                    , DAY.MTH_DESC
                    , DAY.MTH_KEY
                    , DAY.QTR_DESC
                    , DAY.WK_KEY
                    , DAY.WK_DESC
                    , DAY.WK_END_DT
                    , DAY.YR_KEY
                    , DAY.DAY_KEY
                    , TO_VARCHAR(to_date(DAY.DAY_KEY),'DD-MON-YYYY') AS Date_Desc
                    , TO_VARCHAR(to_date(DAY.DAY_KEY),'DD/MM/YYYY') AS  Date
                    ,replace(LTRIM(TO_VARCHAR(to_date(DAY.DAY_KEY),'mm/dd/YY'),0),'/0','/') AS     TY_Date
                    ,replace(LTRIM(TO_VARCHAR(to_date(DAY.DAY_KEY-364),'mm/dd/YY'),0),'/0','/') AS LY_Date
                FROM ${ROBLING_VIEW_DB}.V_DWH_D_TIM_DAY_LU DAY
                WHERE
                DAY.YR_KEY IS NOT NULL AND
                DAY.YR_KEY BETWEEN (SELECT YEAR( CURR_DAY+ INTERVAL '-2 YEAR' ) FROM ${ROBLING_VIEW_DB}.V_DWH_D_CURR_TIM_LU CURR  )
                AND (SELECT YEAR( CURR_DAY ) FROM  ${ROBLING_VIEW_DB}.V_DWH_D_CURR_TIM_LU CURR)
                )Calendar
                ON (Day_Metrics.DAY_KEY=Calendar.DAY_KEY)
                GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36
                )
                Base
                CROSS JOIN DW_DWH_V.V_DY_DWH_C_CONFIG_PARAMS_LU CFG
                WHERE CFG.PARAM_TYPE='SALES_FLASH' AND PARAM_NAME='HIDE_BUDGET_SALES_FLASH_FLG'
                and Base.DAY_KEY IS NOT NULL
                GROUP BY
                1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38
                )