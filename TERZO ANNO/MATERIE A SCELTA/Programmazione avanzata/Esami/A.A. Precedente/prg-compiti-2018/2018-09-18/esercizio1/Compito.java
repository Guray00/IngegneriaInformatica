/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package es1;

/**
 *
 * @author aless_irdbul5
 */
public interface Compito {
	void esegui();
	Object dammiRisultato() throws Exception;
	boolean finito();
	int getTolleranza();
        long getQuando();
        void setException(Exception e);
}

