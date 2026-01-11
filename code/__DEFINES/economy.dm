
#define ACCOUNT_STATUS_OPEN		"open"
#define ACCOUNT_STATUS_FROZEN	"frozen"
#define ACCOUNT_STATUS_CLOSED	"closed"


#define ACCOUNT_NOBLE		"Noble"
#define ACCOUNT_VASSAL		"Vassal"
#define ACCOUNT_GARRISON	"Garrison"
#define ACCOUNT_TOWNSMAN	"Townsman"
#define ACCOUNT_TRADESMAN	"Tradesman"
#define ACCOUNT_PEASANT		"Peasant"
#define ACCOUNT_SERF		"Serf"
#define ACCOUNT_CHURCH		"Church"
#define ACCOUNT_OTHER		"Other"

#define TAX_FOREIGN	"Foreign"
#define TAX_CITIZEN	"Citizen"
#define TAX_LORD	"Lord"

/// The starting values for each of these departments for how much the they are paid from the treasury.
#define DEPARTMENT_WAGES list(, \
	ACCOUNT_NOBLE = 40, \
	ACCOUNT_GUARD = 10, \
	ACCOUNT_SERVANT = 10, \
	ACCOUNT_CHURCH = 10, \
	ACCOUNT_PEASANT = 0, \
)

#define ACCOUNT_CIV "CIV"
#define ACCOUNT_CIV_NAME "Civil Budget"
#define ACCOUNT_ENG "ENG"
#define ACCOUNT_ENG_NAME "Engineering Budget"
#define ACCOUNT_SCI "SCI"
#define ACCOUNT_SCI_NAME "Scientific Budget"
#define ACCOUNT_MED "MED"
#define ACCOUNT_MED_NAME "Medical Budget"
#define ACCOUNT_SRV "SRV"
#define ACCOUNT_SRV_NAME "Service Budget"
#define ACCOUNT_CAR "CAR"
#define ACCOUNT_CAR_NAME "Cargo Budget"
#define ACCOUNT_SEC "SEC"
#define ACCOUNT_SEC_NAME "Defense Budget"
