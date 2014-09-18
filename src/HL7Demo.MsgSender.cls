Class HL7Demo.MsgSender Extends EnsLib.HL7.Operation.TCPOperation
{

Method OnInit() As %Status
{
	//EnsLib.HL7.Adapter.TCPOutboundAdapter
		//Break
		
		Set ..Adapter.Port = "20187"
		Set ..Adapter.IPAddress = "localhost"
		//Set $this.BusinessHost = ##class().%New()
		//Set $this.BusinessHost.Retry = 1
		Quit ##super()
}

Method Send(Msg As EnsLib.HL7.Message)
{
		//Break
		//Do Msg.OutputToDevice()
		Set sc=..SendMessage(Msg,.Ack,$G(^hl7demo.pExpectedSequenceNumber,0))
		//u 0
		//Do Ack.OutputToDevice()
		//ZW Ack
		//Do $system.OBJ.DisplayError(sc)
		//W !,!
}

}

