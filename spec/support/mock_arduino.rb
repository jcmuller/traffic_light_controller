# Mock of class Arduino for testing
class MockArduino
  def initialize(port)
    puts "Mocking arduino board on pretend port #{port}"
  end

  def turnOff
    puts "Turning off all pins"
  end

  def setHigh(pin)
    puts "Setting pin #{pin} to high"
  end

  def close
    puts "Closing connection"
  end

  #def to_s
  #def output(*pinList)
  #def setLow(pin)
  #def isLow?(pin)
  #def isHigh?(pin)
  #def saveState(pin, state)
  #def getState(pin)
  #def analogWrite(pin, value)
  #def analogRead(pin)
  #def sendPin(pin)
  #def sendData(serialData)
  #def getData
end

# Override Arduino class with Mock
Arduino = MockArduino
