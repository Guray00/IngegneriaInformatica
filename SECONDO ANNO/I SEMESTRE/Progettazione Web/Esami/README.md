\begin{frame}[allowframebreaks]
		\frametitle{Perchè abbiamo parlato di array?}	
		Il concetto alla base dei database è che i dati siano memorizzanti in maniera permanente (\emph{persistently stored}). 
		\[\boxed{\text{{Non è assolutamente obbligatoria l'organizzazione di un database in tabelle!}}}\]
		\underline{Possiamo utilizzare il concetto di \emph{array associativo} per organizzare il nostro database}. L'unico requisito, come già anticipato, è mantenere l'unicità delle chiavi nel \emph{namespace}.
		\begin{itemize}
			\item \textbf{Da Wikipedia}. \textit{In computing, a namespace is a set of signs (names) that are used to identify and refer to objects of various kinds. A namespace ensures that all of a given set of objects have unique names so that they can be easily identified}.
			\item In realtà quello che facciamo è garantire l'unicità della chiave all'interno del \emph{namespace} di un \emph{bucket}.
			\framebreak 
			\item Quando parliamo di bucket si pensi a un'area di memoria (a quel punto la chiave consiste nella concatenazione tra nome del bucket e la chiave).
			\item Il database è costituito da più bucket.
		\end{itemize}
	\begin{center}
		\includegraphics[width=0.4\linewidth]{screenshot007}
	\end{center}
		Utile quando non vi sono relazioni complesse tra elementi. 
	\end{frame} 