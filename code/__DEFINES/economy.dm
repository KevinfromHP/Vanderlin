// Payroll ID's. these are used for generation and putting accounts on a payroll.
// If you have a new job that will use a unique payroll it needs to be added here.
#define PAYROLL_NOBLE		"pyrl_noble"
#define PAYROLL_GUARD		"pyrl_guard"
#define PAYROLL_SERVANT		"pyrl_servant"

#define TAX_FOREIGN	"Foreign"
#define TAX_CITIZEN	"Citizen"
#define TAX_LORD	"Lord"

#define ACCOUNT_NOBLE		"Noble"
#define ACCOUNT_VASSAL		"Vassal"
#define ACCOUNT_GARRISON	"Garrison"
#define ACCOUNT_TOWNSMAN	"Townsman"
#define ACCOUNT_TRADESMAN	"Tradesman"
#define ACCOUNT_PEASANT		"Peasant"
#define ACCOUNT_SERF		"Serf"
#define ACCOUNT_CHURCH		"Church"
#define ACCOUNT_OTHER		"Other"

/// The starting payday values for each of these department paydays.
#define DEPARTMENT_WAGES list(, \
	ACCOUNT_NOBLE = 50, \
	ACCOUNT_VASSAL = 30, \
	ACCOUNT_GARRISON = 10, \
	ACCOUNT_TOWNSMAN = 10, \
	ACCOUNT_TRADESMAN = 10, \
	ACCOUNT_PEASANT = 0, \
	ACCOUNT_SERF = 10, \
	ACCOUNT_CHURCH = 10, \
	ACCOUNT_PEASANT = 0, \
)

