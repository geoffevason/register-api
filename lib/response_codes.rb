
# Note - this isn't actually used for anything.  I added this file with the intent of picking up response codes, but it looks like most errror are embeded in the XML when response type is XML.
module Register
  
  SUCCESS = "200"
  
  DOMAIN_AVAILABLE = "210"
  DOMAIN_NOT_AVAILABLE = "211"
  
  NS_AVAILABLE = "212"
  NS_NOT_AVAILABLE = "213"
  
  SUCCESS_AND_CLOSE = "220"

  SERVER_ERROR_CLOSED = "420"
  SERVER_ERROR_TRY_AGAIN = "421"

  INVALID_COMMAND_NAME = "500"
  INVALID_COMMAND_OPTION = "501"
  INVALID_ENTITY_VALUE = "502"
  INVALID_ATTRIBUTE_NAME = "503"
  MISSING_REQURIED_ATTRIBUTE = "504"
  INVALID_ATTRIBUTE_SYNTAX = "505"  
  
  class ResponseCode
    attr_accessor :code, :name, :message
  
    def initialize(code, name, message)
      self.code = code
      self.name = name
      self.message = message
    end
  end
  
  ResponseCode.new(
   "200", "Command completed successfully",
   "This is the normal response for successful completion of most RRP commands."
  )
  
  ResponseCode.new(
   "210", "Domain name available",
   "This is the normal response for successful completion of an RRP CHECK command for a domain name that is not currently registered."
  )
  
  ResponseCode.new(
   "211", "Domain name not available",
   "This is the normal response for successful completion of an RRP CHECK command for a domain name that is currently registered."
  )
  
  ResponseCode.new(
   "212", "Name server available",
   "This is the normal response for successful completion of an RRP CHECK command for a name server that is not currently registered."
  )
  
  ResponseCode.new(
   "213", "Name server not available",
   "This is the normal response for successful completion of an RRP CHECK command for a name server that is currently registered."
  )
  
  ResponseCode.new(
   "220", "Command completed successfully. Server closing connection This is the normal response for successful completion of an RRP QUIT command. It may also be returned by other RRP commands if a transient situation is noted that requires closing the connection after successfully completing the RRP command."
  )
  
  ResponseCode.new(
   "420", "Command failed due to server error. Server closing connection.", 
   "A transient server error has caused RRP command failure and session termination. A new session must be established before continued processing can be attempted."
  )
  
  ResponseCode.new(
   "421", "Command failed due to server error. Client should try again", 
   "A transient server error has caused RRP command failure. A subsequent retry may produce successful results."
  )
  
  ResponseCode.new(
   "500", "Invalid command name",
   "A client-specified RRP command name was not recognized as a valid RRP command name."
  )
  
  ResponseCode.new(
   "501", "Invalid command option", 
   "A client-specified RRP command parameter was not recognized as a valid RRP command parameter."
  )
  
  ResponseCode.new(
   "502", "Invalid entity value",
   "The 'value' of an entity name-value pair is invalid. Command blocks that require an 'EntityName' parameter also require a value that specifies the entity name, and the provided value is invalid."
  )
  
  ResponseCode.new(
   "503", "Invalid attribute name",
   "A client-specified RRP command parameter was not recognized as a valid RRP command parameter."
  )
  
  ResponseCode.new(
   "504", "Missing required attribute",
   "A parameter required to execute the RRP command was not provided by the client. The command should be retried with all required parameters specified."
  )
  
  ResponseCode.new(
   "505", "Invalid attribute value syntax",
   "A supplied parameter value is syntactically incorrect. For example, a year value digit such as '5' may be required but the client provided a string of characters such as 'five'."
  )
  
  ResponseCode.new(
   "506", "Invalid option value",
   "A client-specified value for an RRP command parameter is out-of-bounds or otherwise not within acceptable System limits."
  )
  
  ResponseCode.new(
   "507", "Invalid command format",
   "The specified command does not resemble a well-formed RRP command. The command should be retried using the proper command structure and syntax."
  )
  
  ResponseCode.new(
   "508", "Missing required entity",
   'An entity required for command completion was not provided by the client. For example, the CHECK command requires specification of either a "Domain" entity or a "Nameserver" entity.'
  )
  
  ResponseCode.new(
   "509", "Missing command option",
   "A command parameter that isn't really optional (such as the registrar ID in a SESSION command) was not provided by the client. The command should be retried with all needed parameters."
  )
  
  ResponseCode.new(
   "520", "Server closing connection. Client should try opening new connection;",
   "A timeout event has been detected, and the client's session is being ended.  The System SHOULD define timeout periods to begin a client command, complete a client command, and for the duration of an open session. The reason for the timeout MUST be provided at the end of the response code string."
  )
  
  ResponseCode.new(
   "521", "Too many sessions open. Server closing connection",
   "A System-defined limit on the number of open connections has been exceeded, and it is impossible to establish a new session at the moment. It may be possible to establish a session by waiting for a few moments or by closing existing unused sessions."
  )
  
  ResponseCode.new(
   "530", "Authentication failed",
   "The client-supplied registrar identifier or password was not recognized by the System. A subsequent retry with valid values may produce successful results. Repeated authorization failures MAY result in termination of the TCP connection."
  )
  
  ResponseCode.new(
   "531", "Authorization failed", 
   "Registrars may not view or alter data associated with either the registry or another registrar. This response code is typically returned when a registrar attempts to view or modify data belonging to either the registry or another registrar. A typical situation includes doing a STATUS command for a domain registered to another registrar."
  )
  
  ResponseCode.new(
   "532", "Domain names linked with name server",
   "The name server is hosting active domains. This error occurs when a registrar is trying to delete a server that is the name server for active domains.  The registry MUST not allow the registrar to delete this server. All of the domain names using this server MUST be modified to use a different name server before the name server can be deleted."
  )
  
  ResponseCode.new(
   "533", "Domain name has active name servers",
   "The domain name has active name servers. The registrar is trying to delete a domain name that is a parent domain of an active name server, i.e., a server that is hosting active domains. All of the name servers within the domain MUST be removed from service before the domain can be deleted."
  )
  
  ResponseCode.new(
   "534", "Domain name has not been flagged for transfer"<
   "The registrar is trying to approve or reject a domain name transfer for a domain name that is not pending transfer."
  )
  
  ResponseCode.new(
   "535", "Restricted IP address",
   "IANA identifies certain IP address ranges that are not valid for normal use.  The registrar is trying to use an IP address that is in a restricted IP address range as identified by IANA."
  )
  
  ResponseCode.new(
   "536", "Domain already flagged for transfer",
   "The registrar tried to perform a transfer command for a domain name that is awaiting approval of an earlier transfer request."
  )
  
  ResponseCode.new(
   "540", "Attribute value is not unique",
   "A supplied attribute value is not unique. This occurs when the registrar is adding a domain name that already exists in the registry, a server that already exists in the registry, or an IP address that is already being used by another server in the registry. Another possibility occurs when performing domain modifications and the registrar is adding a server that is already in the list of servers for the domain name or setting a domain name to a status to which it is already set. The RRP STATUS command MAY be used to determine current domain name status before attempting to change the status. When modifying or adding a name server, the IP address of the name server might not be unique. The registry MUST not allow IP addresses to be used by more than one server."
  )
  
  ResponseCode.new(
   "541", "Invalid attribute value",
   "A supplied parameter value is invalid. Examples of invalid attribute values include an invalid IP address, an invalid domain name, an invalid server name, or an invalid renewal period."
  )
  
  ResponseCode.new(
   "542", "Invalid old value for an attribute",
   "A current attribute value to be modified is invalid. The registrar is trying to modify an attribute of a server or a domain name that does not exist in the registry."
  )
  
  ResponseCode.new(
   "543", "Final or implicit attribute cannot be updated",
   "The registrar is attempting to modify an attribute that is only modifiable by the registry. Registrars can not modify final or implicit attribute values."
  )
  
  ResponseCode.new(
   "544", "Entity on hold",
   "The attempted operation was rejected because the entity is on HOLD status. If the HOLD status was set by the registrar, the status can be changed using the MOD command and the requested command can be retried. If the HOLD status was set by the registry, the registrar must contact the registry to change the status before the command can be successful."
  )
  
  ResponseCode.new(
   "545", "Entity reference not found",
   "A required entity reference was not found. This occurs when the registrar tries to add a new name server and the parent domain of the name server does not exist in the registry. It also occurs when the user is trying to add a new name server to a domain name when the name server does not exist in the registry."
  )
  
  ResponseCode.new(
   "546", "Credit limit exceeded",
   "The registrar's credit limit has been exceeded. This is an implementation specific error that occurs when a potentially billable operation, such as adding a domain name, renewing a domain name, or transferring a domain name, is attempted and the registrar does not have sufficient financial standing with the registry to complete the operation."
  )
  
  ResponseCode.new(
   "547", "Invalid command sequence",
   "RRP commands are issued using a well-formed syntax that requires entry of command structures in particular sequences. This response code indicates that an ill-formed command was received and rejected."
  )
  
  ResponseCode.new(
   "548", "Domain is not up for renewal",
   "A RENEW command was attempted during a period in which the domain can not be renewed. Implementations MAY limit renewal periods to particular time frames, such as within 90 days of the domain's expiration. This response indicates that the RENEW command was received outside of the System-defined domain renewal period."
  )
  
  ResponseCode.new(
   "549", "Command failed",
   "A System error prevented successful completion of the requested RRP command.  Retrying the command might produce success, but a repeated failure indicates a System error condition."
  )
  
  ResponseCode.new(
   "550", "Parent domain not registered",
   "The parent domain of a name server being registered is not registered. This occurs when the registrar tries to add a new name server and the parent domain for the server does not exist in the registry."
  )
  
  ResponseCode.new(
   "551", "Parent domain status does not allow for operation",
   "The status of the parent domain does not allow the requested operation. This occurs when a registrar tries to modify a server whose parent domain is flagged as LOCK or HOLD in the registry."
  )
  
  ResponseCode.new(
   "552", "Domain status does not allow for operation",
   "The status of the domain does not allow the requested operation. This occurs when a registrar tries to modify or delete a domain that is flagged as LOCK or HOLD in the registry."
  )
  
  ResponseCode.new(
   "553", "Operation not allowed. Domain pending transfer",
   "The status of the domain does not allow the requested operation. The registrar is attempting to delete a domain that is pending approval or denial of a transfer request."
  )
  
  ResponseCode.new(
   "554", "Domain already registered",
   "A registrar tried to register a domain name that has already been registered by the same registrar."
  )
  
  ResponseCode.new(
   "555", "Domain already renewed",
   "A registrar tried to renew a domain using the same parameters as specified for an earlier, successful renewal. This will commonly occur when executing the same RENEW command more than once."
  )
  
  ResponseCode.new(
   "556", "Maximum registration period exceeded",
   "A registrar tried to renew a domain registration, and the resulting new registration period exceeds the System-defined maximum registration period. If there is renewal time available with the System-defined maximum registration period it may be possible to retry the RENEW command with specified renewal period parameters."
  )
end
  
