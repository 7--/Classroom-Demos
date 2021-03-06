package com.revature.jaxp;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

public class TurtleHandler extends DefaultHandler {
	@Override
	public void startElement(String uri, String localname, String qName, Attributes attributes) throws SAXException {
		System.out.println(qName + ": ");
	}
	
	@Override
	public void endElement(String uri, String localName, String qName) throws SAXException {
		System.out.println("end " + qName);
	}
	
	@Override
	public void characters (char[] ch, int start, int length) throws SAXException {
		System.out.println(new String (ch, start, length));
	}
}
